#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook playbooks/puppetmaster.yml \
-i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT"

#cleanup
[ $? -eq 0 ] && ssh-agent -k
