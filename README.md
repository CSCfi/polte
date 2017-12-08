# polte

An Ansible playbook for creating a Heat stack for hosting various OpenStack
components.

This playbook is intended for providing a minimal environment for development
purposes. It disables certain HA features, such as Pacemaker. Thus it is not
suitable for deploying production environments.

## Caveats

* The ceph nodes are not currently provisioned by site.yml
* Running site.yml may take a long time. Before root cause is fixed, consider
  halting the 3rd puppetize run of the API nodes after about 15 minutes for
  fastest results.

## Requirements

* ansible >= 2.3
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
* Run playbook (--ask-vault-pass presumed but not mandatory):

`$ ansible-playbook -i inventory site.yml --ask-vault-pass`

## Contributors

* Risto Laurikainen - https://github.com/rlaurika
  * Heat stack (adapted from https://github.com/CSCfi/etherpad-deployment-demo)
* Jukka Nousiainen - https://github.com/junousi
  * Hacks & bugs
