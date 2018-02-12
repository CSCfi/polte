#!/bin/bash +xe
TIMEOUT=1200

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
timeout $TIMEOUT ansible-playbook -i inventory playbooks/puppetize_objs.yml -e "puppet_environment=$PUPPET_ENVIRONMENT"
if [ $? -eq 0 ]; then ssh-agent -k && exit 0; fi
timeout $TIMEOUT ansible-playbook -i inventory playbooks/puppetize_objs.yml -e "puppet_environment=$PUPPET_ENVIRONMENT"
if [ $? -eq 0 ]; then ssh-agent -k && exit 0; fi

#cleanup
[ $? -eq 0 ] && ssh-agent -k
