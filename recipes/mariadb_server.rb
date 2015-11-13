#
# Cookbook Name:: opennebula_ng
# Recipe:: mariadb_server
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

# Install MariaDB + Galera
include_recipe 'mysqld::mariadb_repository'
include_recipe 'mysqld::mariadb_galera_install'
include_recipe 'mysqld::configure'

# GRANT oneadmin user access to opennebula database
query = %(GRANT ALL PRIVILEGES ON #{node['opennebula_ng']['mysql']['db_name']}.*
          TO '#{node['opennebula_ng']['mysql']['user']}'
          IDENTIFIED BY '#{node['opennebula_ng']['mysql']['passwd']}')

# Use debian.cnf for authentication, run GRANT statement
if node['opennebula_ng']['active']
  execute %(mysql --defaults-file=/etc/mysql/debian.cnf -e "#{query}")
end
