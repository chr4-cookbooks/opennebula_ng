#
# Cookbook Name:: opennebula_ng
# Attributes:: mysql
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

# Default mysql database settings
default['opennebula_ng']['mysql']['server']  = 'localhost'
default['opennebula_ng']['mysql']['port']    = 3306
default['opennebula_ng']['mysql']['user']    = 'oneadmin'
default['opennebula_ng']['mysql']['passwd']  = 'oneadmin'
default['opennebula_ng']['mysql']['db_name'] = 'opennebula'

# Listen on all interfaces by default
default['mysqld']['my.cnf']['mysqld']['bind-address'] = '0.0.0.0'

# Settings required by Galera
default['mysqld']['my.cnf']['mysqld']['wsrep_provider'] = '/usr/lib/galera/libgalera_smm.so'
default['mysqld']['my.cnf']['mysqld']['wsrep_cluster_address'] = 'gcomm://localhost'
default['mysqld']['my.cnf']['mysqld']['binlog_format'] = 'ROW'
default['mysqld']['my.cnf']['mysqld']['default_storage_engine'] = 'InnoDB'
default['mysqld']['my.cnf']['mysqld']['innodb_autoinc_lock_mode'] = 2
default['mysqld']['my.cnf']['mysqld']['innodb_doublewrite'] = 1
default['mysqld']['my.cnf']['mysqld']['query_cache_size'] = 0
