#
# Cookbook Name:: opennebula_ng
# Recipe:: lvm
#
# Copyright (C) 2014 Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'tempfile'

package 'lvm2'

# Add oneadmin user to disk group
group 'disk' do
  members 'oneadmin'
  append  true
  action  :modify
end

# Create datastores
if node['opennebula_ng']['active']
  node['opennebula_ng']['lvm']['datastores'].each do |name, config|
    tempfile = Tempfile.new(%w(opennebula .conf))

    execute "onedatastore create #{tempfile.path}" do
      env 'ONE_AUTH' => node['opennebula_ng']['one_auth']['oneadmin']['auth_file'],
          'HOME' => node['opennebula_ng']['one_auth']['oneadmin']['home']
      action :nothing
    end

    # Generate config file
    ruby_block "generate datastore config file (#{name})" do
      block do
        tempfile.write(%(NAME = "#{name}"\n))
        config.each do |key, value|
          tempfile.write(%(#{key.upcase} = "#{value}"\n))
        end
        tempfile.close
        Chef::Log.info("Created temporary file with datastore configuration in #{tempfile.path}")
      end

      notifies :run, "execute[onedatastore create #{tempfile.path}]"

      # Do not execute if this datastore is already is existent
      not_if ["ONE_AUTH=#{node['opennebula_ng']['one_auth']['oneadmin']['auth_file']}",
              "HOME=#{node['opennebula_ng']['one_auth']['oneadmin']['home']}",
              "onedatastore list --csv |grep -q '#{name}'"].join(' ')
    end
  end
end

# Only allow physical HDs, because virtual machine PVs
# provoke "duplicate UUID" errors  when present
lvm_conf = Chef::Util::FileEdit.new('/etc/lvm/lvm.conf')
lvm_conf.search_file_replace_line(/^\s*filter/, %(    filter = [ "a|^/dev/hd.*|", "a|^/dev/sd.*|", "r/.*/" ]))
lvm_conf.write_file
