# polte

An Ansible playbook for provisioning Openstack and Ceph into a Heat stack.

This playbook is intended for providing a minimal environment for development
purposes. It disables certain HA features from the CSC Common Cloud Platform
Puppet module. Thus it is not suitable for deploying production environments.

## Caveats

* Ceph is not currently provisioned by site.yml.
* Running site.yml may take a long time. Before root cause is fixed, consider
  halting the 3rd puppetize run of the API nodes after about 15 minutes for
  fastest results.
* Multiple stacks in a project are not supported. For solving this, unique
  hostnames per Heat stack may be required. Thus a contraption which
  supports dynamic hostnames in Hiera data may be required.

## Requirements

* ansible >= 2.4
* shade >= 1.8.0

## Installation

* Install roles from requirements.yml
* Load keys into SSH agent
* Load keys into environment (see README.md in ansible-role-puppetmaster)
* Source openrc.sh
* Provide host_vars (ansible-vault is presumed but not mandatory):
  * vault_puppet_environments_repo - SSH git URL to Hiera data repository
  * vault_openldap_server_rootpw - Root password for LDAP server
  * vault_testuser_password - Hashed into userPassword LDAP attribute
  * vault_keystone_password - Hashed into userPassword LDAP attribute
  * vault_heat_password - Hashed into userPassword LDAP attribute
  * vault_neutron_password - Hashed into userPassword LDAP attribute
  * vault_glance_devel_key - Ceph key identical to hieradata key
  * vault_cinder_devel_key - Ceph key identical to hieradata key
  * vault_nova_devel_key - Ceph key identical to hieradata key
  * vault_radosgw_devel_key - Ceph key identical to hieradata key
* Run playbook (--ask-vault-pass presumed but not mandatory):

`$ ansible-playbook -i inventory site.yml --ask-vault-pass`

## Contributors

* Risto Laurikainen - https://github.com/rlaurika
  * Heat stack (adapted from https://github.com/CSCfi/etherpad-deployment-demo)
* Jukka Nousiainen - https://github.com/junousi
  * Hacks & bugs
