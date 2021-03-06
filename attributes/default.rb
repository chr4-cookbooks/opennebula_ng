#
# Cookbook Name:: opennebula_ng
# Attributes:: default
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

# OpenNebula doesn't allow multiple active nodes. Set this to true on your currently active
# OpenNebula host to automatically enable/start the frontend services (oned, scheduler, sunstone)
default['opennebula_ng']['active'] = false

# Default OpenNebula version to install
# (used by the apt_repository recipe to install the appropriate repository)
default['opennebula_ng']['version'] = '5.0'
