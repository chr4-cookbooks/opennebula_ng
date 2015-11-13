#
# Cookbook Name:: opennebula_ng
# Attributes:: one_auth
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

# Set shared passwords between all opennebula hosts for serveradmin and oneadmin
default['opennebula_ng']['one_auth']['oneadmin']['id'] = 0
default['opennebula_ng']['one_auth']['oneadmin']['password'] = nil
default['opennebula_ng']['one_auth']['serveradmin']['id'] = 1
default['opennebula_ng']['one_auth']['serveradmin']['password'] = nil

# Configure oneadmin home directory and the auth_file
default['opennebula_ng']['one_auth']['oneadmin']['home'] = '/var/lib/one'
default['opennebula_ng']['one_auth']['oneadmin']['auth_file'] = '/var/lib/one/.one/one_auth'

# Set ssh keypair for oneadmin user (as each opennebula machine needs to be able to connect to each other host)
default['opennebula_ng']['one_auth']['oneadmin']['id_rsa'] = nil
default['opennebula_ng']['one_auth']['oneadmin']['id_rsa.pub'] = nil
