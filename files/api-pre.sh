#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook -i inventory playbooks/pre_puppetize_apis.yml

#cleanup
[ $? -eq 0 ] && ssh-agent -k
