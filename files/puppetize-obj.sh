#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppetize_objs.yml
if [ $? -eq 0 ]; then ssh-agent -k && exit 0; fi
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppetize_objs.yml

#cleanup
[ $? -eq 0 ] && ssh-agent -k
