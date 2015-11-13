#
# Cookbook Name:: opennebula_ng
# Attributes:: network
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

# ipv4
default['opennebula_ng']['interfaces']['br0']['inet']['type'] = 'static'
default['opennebula_ng']['interfaces']['br0']['inet']['address'] = nil
default['opennebula_ng']['interfaces']['br0']['inet']['network'] = nil
default['opennebula_ng']['interfaces']['br0']['inet']['netmask'] = nil
default['opennebula_ng']['interfaces']['br0']['inet']['broadcast'] = nil
default['opennebula_ng']['interfaces']['br0']['inet']['gateway'] = nil

default['opennebula_ng']['interfaces']['br0']['inet']['bridge_ports'] = 'eth0'
default['opennebula_ng']['interfaces']['br0']['inet']['bridge_fd'] = 9
default['opennebula_ng']['interfaces']['br0']['inet']['bridge_hello'] = 2
default['opennebula_ng']['interfaces']['br0']['inet']['bridge_maxage'] = 12
default['opennebula_ng']['interfaces']['br0']['inet']['bridge_stp'] = 'off'

default['opennebula_ng']['interfaces']['br0']['inet']['dns-nameservers'] = nil
default['opennebula_ng']['interfaces']['br0']['inet']['dns-search'] = nil

# ipv6
default['opennebula_ng']['interfaces']['br0']['inet6']['type'] = 'static'
default['opennebula_ng']['interfaces']['br0']['inet6']['address'] = nil
default['opennebula_ng']['interfaces']['br0']['inet6']['netmask'] = nil
default['opennebula_ng']['interfaces']['br0']['inet6']['gateway'] = nil
