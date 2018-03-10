#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook -i inventory playbooks/post_puppetize_apis.yml

#cleanup
if [ $? -eq 0 ]; then
#  openstack stack delete MULTIBRANCH_"$PUPPET_ENVIRONMENT"
#  rm inventory/ooo_inventory
  ssh-agent -k
  exit 0
else
  ssh-agent -k
  exit 1
fi
