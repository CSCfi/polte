#!/bin/bash +xe

#env
source ansible_shell_env.sh

#run
ansible-playbook -i inventory playbooks/upgrade_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
