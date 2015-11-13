#
# Cookbook Name:: opennebula_ng
# Recipe:: virtual_networks
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

# Create virtual networks
if node['opennebula_ng']['active']
  node['opennebula_ng']['virtual_networks'].each do |name, config|
    tempfile = Tempfile.new(%w(opennebula .one))

    execute "onevnet create #{tempfile.path}" do
      env 'ONE_AUTH' => node['opennebula_ng']['one_auth']['oneadmin']['auth_file'],
          'HOME' => node['opennebula_ng']['one_home']
      action :nothing
    end

    # Generate config file
    ruby_block "generate virtual network config file (#{name})" do
      block do
        tempfile.write(%(NAME = "#{name}"\n))
        config.each do |key, value|

          # Items might be specified multiple times.
          # This is currenlty only used by AR
          [value].flatten.each do |v|

            # If v is a hash, add a KEY=[] block
            # This is currently only used by AR
            if v.is_a?(Hash)
              tempfile.write("#{key.upcase}=[\n")
              lines = []
              v.each { |k, v| lines << %(  #{k.upcase} = "#{v}") }
              tempfile.write(lines.join(",\n"))
              tempfile.write("\n]\n")
            else
              Array(value).each do |v|
                tempfile.write(%(#{key.upcase} = "#{v}\n"))
              end
            end
          end
        end

        tempfile.close
        Chef::Log.info("Created temporary file with virtual network configuration in #{tempfile.path}")
      end

      notifies :run, "execute[onevnet create #{tempfile.path}]"

      # Do not execute if this virtual network is already is existent
      not_if ["ONE_AUTH=#{node['opennebula_ng']['one_auth']['oneadmin']['auth_file']}",
              "HOME=#{node['opennebula_ng']['one_home']}",
              "onevnet list --csv |grep -q '#{name}'"].join(' ')
    end
  end
end
