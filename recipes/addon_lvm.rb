#
# Cookbook Name:: opennebula_ng
# Recipe:: addon_lvm
#
# Copyright (C) 2016 Chris Aumann
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

# This recipe installs the OpenNebula LVM addon.
#
# Since there are no releases published (yet), we need to checkout the git repository.
# I've opened an issue to address this: https://github.com/OpenNebula/addon-lvm/issues/3

execute 'install_lvm_addon' do
  command './install.sh'
  cwd "#{Chef::Config[:file_cache_path]}/opennebula_lvm_addon"
  action :nothing
end

git "#{Chef::Config[:file_cache_path]}/opennebula_lvm_addon" do
  revision   node['opennebula_ng']['lvm']['branch']
  repository node['opennebula_ng']['lvm']['repository']

  # Run installer, this also automatically installs updates from upstream!
  notifies :run, 'execute[install_lvm_addon]'
end
