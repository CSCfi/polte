#!/bin/bash +xe

#env
source ansible_shell_env.sh

#run
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppetize_backends.yml
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppetize_backends.yml
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppetize_backends.yml
if [ $? -eq 0 ]; then exit 0; fi
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppetize_backends.yml
