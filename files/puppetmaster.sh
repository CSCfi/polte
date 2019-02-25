#!/bin/bash +xe

#env
source ansible_shell_env.sh

#run
ansible-playbook -i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT cccp_branch=$1" \
playbooks/puppetmaster.yml
if [ ! $? -eq 0 ]; then
  ansible-playbook -i inventory \
  playbooks/generate_hostsfile.yml \
  --limit puppet-node

  ansible-playbook -i inventory \
  -e "puppet_environment=$PUPPET_ENVIRONMENT" \
  playbooks/puppet_environment_mods.yml

  ansible-playbook -i inventory \
  -e "puppet_environment=$PUPPET_ENVIRONMENT cccp_branch=$1" \
  playbooks/puppetmaster.yml;
fi
if [ ! $? -eq 0 ]; then exit 1; fi

ansible-playbook -i inventory \
playbooks/generate_hostsfile.yml \
--limit puppet-node

ansible-playbook -i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT" \
playbooks/puppet_environment_mods.yml
