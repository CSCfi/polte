# polte

An Ansible playbook for creating a Heat stack for hosting various OpenStack
components.

## Requirements

* Ansible >= 2.3
* shade >= 1.8.0

## Caveats

Agent is forwarded to all connections. Think about what kind of keys you are
forwarding and modify this behavior if necessary.

## Installation

* Install roles

`$ ansible-galaxy -r requirements.yml install`

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
* Run (adding --ask-vault-pass if such in use):

`$ ansible-playbook -i inventory site.yml`

## Contributors

* Risto Laurikainen - https://github.com/rlaurika
  * Heat stack ( https://github.com/CSCfi/etherpad-deployment-demo )
* Jukka Nousiainen - https://github.com/junousi
  * Hacks & bugs