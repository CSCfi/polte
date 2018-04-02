#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook -i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT" \
playbooks/puppetmaster.yml
if [ ! $? -eq 0 ]; then
#Some kind of delay in iptables rule propagation, related to the
#newly created router, impacting DNS momentarily.
  sleep 120;
  ansible-playbook -i inventory \
  -e "puppet_environment=$PUPPET_ENVIRONMENT" \
  playbooks/puppetmaster.yml;
fi
if [ ! $? -eq 0 ]; then ssh-agent -k && exit 1; fi

ansible-playbook -i inventory \
playbooks/generate_hostsfile.yml \
--limit puppet-node

ansible-playbook -i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT" \
playbooks/puppet_environment_mods.yml

#cleanup
[ $? -eq 0 ] && ssh-agent -k
