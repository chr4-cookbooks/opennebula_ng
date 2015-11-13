#
# Cookbook Name:: opennebula_ng
# Recipe:: one_auth
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

# Deploy /var/lib/one/.one/ secrets (oneuser password)
execute 'Set oneuser passwd for serveradmin' do
  user 'oneadmin'
  command "oneuser passwd #{node['opennebula_ng']['one_auth']['serveradmin']['id']} #{node['opennebula_ng']['one_auth']['serveradmin']['password']} --sha1"
  action :nothing
  only_if { node['opennebula_ng']['active'] }
end

# The password for the user oneadmin needs to be set before we change the one_auth file. Once the
# one_auth file is changed, it will be used to authenticate when using "oneuser" and will then fail
# if the password wasn't changed before.
execute 'Set oneuser passwd for oneadmin' do
  user 'oneadmin'
  command "oneuser passwd #{node['opennebula_ng']['one_auth']['oneadmin']['id']} #{node['opennebula_ng']['one_auth']['oneadmin']['password']}"
  only_if  { node['opennebula_ng']['one_auth']['oneadmin']['password'] && node['opennebula_ng']['active'] }
end

%w(ec2_auth occi_auth oneflow_auth onegate_auth sunstone_auth).each do |file|
  file "/var/lib/one/.one/#{file}" do
    mode    00600
    user    'oneadmin'
    group   'oneadmin'
    content "serveradmin:#{node['opennebula_ng']['one_auth']['serveradmin']['password']}\n"
    notifies :run, 'execute[Set oneuser passwd for serveradmin]'
    only_if  { node['opennebula_ng']['one_auth']['serveradmin']['password'] }
  end
end

file '/var/lib/one/.one/one_auth' do
  mode    00600
  user    'oneadmin'
  group   'oneadmin'
  content "oneadmin:#{node['opennebula_ng']['one_auth']['oneadmin']['password']}\n"
  only_if  { node['opennebula_ng']['one_auth']['oneadmin']['password'] }
end

# Every opennebula host needs access to other hosts as the oneuser.
# Deploy /var/lib/one/.ssh/ keys and authorized keys.
file '/var/lib/one/.ssh/id_rsa' do
  mode    00600
  owner   'oneadmin'
  group   'oneadmin'
  content "#{node['opennebula_ng']['one_auth']['oneadmin']['id_rsa']}\n"
  only_if { node['opennebula_ng']['one_auth']['oneadmin']['id_rsa'] }
end

%w(/var/lib/one/.ssh/authorized_keys /var/lib/one/.ssh/id_rsa.pub).each do |pubkey_file|
  file pubkey_file do
    mode    00644
    owner   'oneadmin'
    group   'oneadmin'
    content "#{node['opennebula_ng']['one_auth']['oneadmin']['id_rsa.pub']}\n"
    only_if { node['opennebula_ng']['one_auth']['oneadmin']['id_rsa.pub'] }
  end
end
