#
# Cookbook Name:: opennebula_ng
# Recipe:: mariadb_galera
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

# /etc/one/oned.conf is part of the package "opennebula".
# Make sure it's installed
package 'opennebula'

service 'opennebula' do
  # Enable service on active nodes
  action :enable if node['opennebula_ng']['active']
end

# Configure OpenNebula to use MariaDB
# Exchange DB = [] configuration in /etc/one/oned.conf with settings in attributes
#
# TODO: Somehow the regex doesn't match multiline expressions, even when using /m
oned_conf = nil
ruby_block 'Edit oned.conf' do
  block do
    oned_conf = Chef::Util::FileEdit.new('/etc/one/oned.conf')
    oned_conf.search_file_replace_line(/^\s*DB\s*=\s*\[.*?\]/m, %(DB = [ backend = "mysql",
      server  = "#{node['opennebula_ng']['mysql']['server']}",
      port    = #{node['opennebula_ng']['mysql']['port']},
      user    = "#{node['opennebula_ng']['mysql']['user']}",
      passwd  = "#{node['opennebula_ng']['mysql']['passwd']}",
      db_name = "#{node['opennebula_ng']['mysql']['db_name']}" ]
    ))
    oned_conf.write_file

    # Notify opennebula service if the file was changed
    self.notifies :restart, 'service[opennebula]' if oned_conf.file_edited?
  end
end

