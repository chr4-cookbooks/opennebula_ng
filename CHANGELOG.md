5.1.0
-----

- Add `addon_lvm` recipe, to install the official [OpenNebula LVM Addon](https://github.com/OpenNebula/addon-lvm)

5.0.0
-----

- Add `node['opennebula_ng']['version']` attribute to allow installing a specific version
- Update default OpenNebula version to `5.0`

4.14.3
------

- Add posibility to configure interfaces without an ip address (for bridges).
  For this to work, a safeguard was removed that prevented interface configuration to be written to
  `/etc/network/interfaces` when no address was set.

4.14.2
------

- Re-license under GPLv3

4.14.1
------

- Update default OpenNebula version to `4.14`

4.12.1
------

- **BREAKING CHANGE:** Add support for ipv6. Network configuration adaption required!

```ruby
# Change
node['opennebula_ng']['interfaces']['br0']['type'] = 'inet static'
node['opennebula_ng']['interfaces']['br0']['address'] = '192.168.1.100'

# To:
node['opennebula_ng']['interfaces']['br0']['inet']['type'] = 'static'
node['opennebula_ng']['interfaces']['br0']['inet']['address'] = '192.168.1.100'
```

4.12.0
------

- Update default OpenNebula version to `4.12.0`

4.10.1
------

- Allow multiple ARs (address-ranges) in virtual network configuration

4.10.0
------

- Use OpenNebula 4.10 repositories. To upgrade, run `apt-get dist-upgrade` after deploying the
  cookbook. Make sure you also run the database migrations using `onedb upgrade`.

4.8.5
-----

- Support new address range (AR) syntax in `virtual_network` recipe
- Use --sha1 when changing password for serveradmin
- Deploy `id_rsa.pub` alongside `id_rsa`
- Do not automatically restart network configuration. This is problematic, as it cuts off virtual
  machines from their network bridges.

4.8.4
-----

- Fail hard when not using a valid network configration, instead of deploying an empty
  /etc/network/interfaces

4.8.3
-----

- Add `node['opennebula_ng']['active']` attribute, which defaults to false. On non-active opennebula
  hosts we won't add networks/storage/users and will disable oned, scheduler and sunstone services,
  as OpenNebula is not capable of running as an active-active environment due to caching issues.

Compatibility changes:
- Set `node['opennebula_ng']['active'] = true` on your currently active (master) host

4.8.2
-----

- Add one\_auth recipe, to set shared passwords for "oneadmin" and "serveradmin" users, as well as
  deploy ssh keys

Compatibility changes:
- Renamed `node['opennebula_ng']['one_auth']` attribtue to `node['opennebula_ng']['one_auth']['oneadmin']['auth_file']`
- Renamed `node['opennebula_ng']['one_home']` attribute to `node['opennebula_ng']['one_auth']['oneadmin']['home']`

4.8.1
-----

- Use mariadb galera by default

4.8.0
-----

- Upgrade to OpenNebula 4.8 packages

0.1.0
-----

- Initial release of opennebula\_ng
