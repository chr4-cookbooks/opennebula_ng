# opennebula\_ng cookbook

A cookbook for managing [OpenNebula](http://opennebula.org/) via the Chef configuration management tool.

## Supported Platforms

* Debian
* Ubuntu

## Quickstart

To setup a minimal configuration, standalone OpenNebula server, set the following attributes to configure your network

```ruby
node['opennebula_ng']['interfaces']['br0']['type'] = 'inet static'
node['opennebula_ng']['interfaces']['br0']['address'] = '192.168.1.100'
node['opennebula_ng']['interfaces']['br0']['network'] = '192.168.1.0'
node['opennebula_ng']['interfaces']['br0']['netmask'] = '255.255.255.0'
node['opennebula_ng']['interfaces']['br0']['broadcast'] = '192.168.1.255'
node['opennebula_ng']['interfaces']['br0']['gateway'] = '192.168.1.1'
```

And run the following recipes:

* default
* sunstone
* node
* register\_nodes


This will do the following things

* Install the Sunstone frontend
* Configure the network, add OpenNebula bridge
* Register the current host as an OpenNebula node

You should be able to connect to your new OpenNebula installation using `http://yourhost.com:9869`


## Recipes

### default

The default recpe just includes the `apt_repository` recipe


### apt\_repository

This recipe sets up the official OpenNebula PPA for Ubuntu (stable)


### sunstone

This recipe installs and configures the sunstone frontend.

* Installs opennebula and opennebula-sunstone packages
* Takes care of SSH and authorized\_keys configuration


### node

This recipe turns your machine into an opennebula node

* Configures networking according to node attributes (DANGER: touches `/etc/network/interfaces`)
* Configures the OpenNebula bridge interface
* Configures qEMU
* Configures libvirt

*MAKE SURE* you configure the following attributes (e.g. create one file for each node in your
wrapper cookbooks attribute dir, e.g. `attributes/myhost1.rb`)

```ruby
if node.name == 'myhost1'
  node['opennebula_ng']['interfaces']['br0']['type'] = 'inet static'
  node['opennebula_ng']['interfaces']['br0']['address'] = '192.168.1.100'
  node['opennebula_ng']['interfaces']['br0']['network'] = '192.168.1.0'
  node['opennebula_ng']['interfaces']['br0']['netmask'] = '255.255.255.0'
  node['opennebula_ng']['interfaces']['br0']['broadcast'] = '192.168.1.255'
  node['opennebula_ng']['interfaces']['br0']['gateway'] = '192.168.1.1'

  node['opennebula_ng']['interfaces']['br0']['bridge_ports'] = 'eth0'
  node['opennebula_ng']['interfaces']['br0']['bridge_fd'] = 9
  node['opennebula_ng']['interfaces']['br0']['bridge_hello'] = 2
  node['opennebula_ng']['interfaces']['br0']['bridge_maxage'] = 12
  node['opennebula_ng']['interfaces']['br0']['bridge_stp'] = 'off'
end
```

You can also configure additional interfaces, if required

```ruby
node['opennebula_ng']['interfaces']['br1']['type'] = 'inet static'
node['opennebula_ng']['interfaces']['br1']['address'] = '10.0.0.100'
node['opennebula_ng']['interfaces']['br1']['network'] = '10.0.0.0'
node['opennebula_ng']['interfaces']['br1']['netmask'] = '255.255.255.0'
node['opennebula_ng']['interfaces']['br1']['broadcast'] = '10.0.0.255'

node['opennebula_ng']['interfaces']['br1']['bridge_ports'] = 'eth1'
node['opennebula_ng']['interfaces']['br1']['bridge_fd'] = 9
node['opennebula_ng']['interfaces']['br1']['bridge_hello'] = 2
node['opennebula_ng']['interfaces']['br1']['bridge_maxage'] = 12
node['opennebula_ng']['interfaces']['br1']['bridge_stp'] = 'off'
```

### mysql\_server

Configures OpenNebula to use a MySQL backend.
You can set the package to install using the following attribute (defaults to `mariadb-server`)

```ruby
node['opennebula_ng']['mysql']['package'] = 'mysql-server'
```

Adjust the following attributes in case they are different from the defaults:

```ruby
# Default mysql database settings
node['opennebula_ng']['mysql']['server']  = 'localhost'
node['opennebula_ng']['mysql']['port']    = 0
node['opennebula_ng']['mysql']['user']    = 'oneadmin'
node['opennebula_ng']['mysql']['passwd']  = 'oneadmin'
node['opennebula_ng']['mysql']['db_name'] = 'opennebula'
```


### register\_nodes

This recipe registers your hosts at oned.

The configuration is set via attributes, and supports all parameters that `onehost` supports.

The default is to register the node chef is currently running on, using kvm

```ruby
# You can add all your nodes centrally here
node['opennebula_ng']['nodes'] = {
  myhost1: { im: 'kvm', vm: 'kvm', net: 'dummy' },
  myhost2: { im: 'kvm', vm: 'kvm', net: 'dummy' },
  myhost3: { im: 'kvm', vm: 'kvm', net: 'dummy' },
}
```


### virtual\_networks

This recipe registers virtual networks using `onenet`.

You can specify your network configuration using the following attributes. Both `fixed` and `ranged`
networks are supported.

```ruby
node['opennebula_ng']['virtual_networks'] = {
  frontnet: {
    TYPE: 'fixed',
    BRIDGE: 'br0',
    GATEWAY: '192.168.1.1',
    NETWORK_MASK: '255.255.255.0',
    NETWORK_ADDRESS: '192.168.1.0',
    DNS: '"208.67.222.222 208.67.220.220"',
    LEASES: ['[ IP=192.168.1.100 ]', '[ IP=192.168.1.101 ]']
  },
  backnet: {
    TYPE: 'ranged',
    BRIDGE: 'br1',
    NETWORK_MASK: '255.255.255.0',
    NETWORK_ADDRESS: '10.0.0.0',
    IP_START: '10.0.0.100',
    IP_END: '10.0.0.200',
  },
}
```


### lvm

A recipe to configure LVM datastores.

* Installs and configures lvm packages
* Creates datastores according to attributes

You can configure the datastores using the following attributes:

```ruby
node['opennebula_ng']['lvm']['datastores'] = {
  'my datastore' => {
    DS_MAD: 'lvm',
    TM_MAD: 'lvm',
    DISK_TYPE: 'BLOCK',
    VG_NAME: 'vg-one',
    BRIDGE_LIST: node['hostname'], # Add all hostnames of hosts accessing this datastore
  }
}
```


### nfs\_server

This recipe configures the host to be a NFS server. It can be configured using the following
attributes:

```ruby
# Network to export NFS directories to, defaults to all hosts
node['opennebula_ng']['nfs']['network'] = '*' # or a network like e.g. '10.0.0.0/24'

# NFS fsid. Must be unique
node['opennebula_ng']['nfs']['fsid'] = 1

# Hostname/IP of the NFS server (usually the frontend machine)
node['opennebula_ng']['nfs']['server'] = 'myhost1'
```


### nfs\_client

Configures the host to be an NFS client, mouting `/var/lib/one` from the server stored in
`node['opennebula_ng']['nfs']['server']`


## Other attributes

You can configure the location of the "oneadmin" home directory and auth file in case needed.

```ruby
node['opennebula_ng']['one_auth'] = '/var/lib/one/.one/one_auth'
node['opennebula_ng']['one_home'] = '/var/lib/one'
```


## Notes

Please be aware, that you probably want a reverse proxy like [nginx](http://nginx.org) incl. SSL
before you deploy OpenNebula to your production servers.

You can easily do this e.g. using the
[certificate](https://github.com/atomic-penguin/cookbook-certificate) and
[nginx](https://github.com/miketheman/nginx) cookbooks.



## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Chris Aumann (<me@chr4.org>)
| **Copyright:**       | Copyright (c) 2014 Vaamo Finanz AG
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
