#!/bin/bash +xe

#env
source ansible_shell_env.sh

#run
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
