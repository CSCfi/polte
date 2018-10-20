#!/bin/bash +x
set +xe

#ansible variables
mkdir -p inventory/host_vars/ldap-node
cp /var/lib/jenkins/credentials/vault-ldapnode.yml inventory/host_vars/ldap-node/vault.yml
cp /var/lib/jenkins/credentials/vault-ldapnode.yml inventory/group_vars/api/vault.yml
cp /var/lib/jenkins/credentials/vault-puppetnode.yml inventory/host_vars/puppet-node/vault.yml
cp /var/lib/jenkins/credentials/vault-all.yml inventory/group_vars/all/vault.yml
cp /var/lib/jenkins/credentials/heat-params.yml files/heat-params.yml

#shell environment variables
source "{{ openrc_location }}"
export OS_PASSWORD=$(cat "{{ os_password_location }}")
export OS_KEY_FILE="{{ os_key_file_location }}"
export VAULT_PASS_FILE="{{ vault_pass_file_location }}"
export HIERA_PRIVATE_KEY="$(cat "{{ hiera_private_key_location }}")
export HIERA_PUBLIC_KEY="$(cat "{{ hiera_public_key_location }}")

#ansible cfg
echo "vault_password_file=$VAULT_PASS_FILE" >> ansible.cfg
echo "ansible_ssh_private_key_file=$OS_KEY_FILE" >> ansible.cfg

#puppet env
source puppet_env.sh
