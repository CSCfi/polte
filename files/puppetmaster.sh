#!/bin/bash +xe

#env
source ansible_shell_env.sh

#run

#provision puppetmaster, inject cccp branch, rubygem hack, puppetserver restart
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT cccp_branch=$1" playbooks/puppetmaster.yml
#regenerate the hosts file because puppet apply screws it up
ansible-playbook -i inventory  playbooks/generate_hostsfile.yml --limit puppet-node
#puppetize puppetmaster because that's what the role would have liked to do?
ansible -m shell -i inventory -a "sudo /opt/puppetlabs/bin/puppet agent -t" puppet-node

if [ ! $? -eq 0 ]; then
  #re-regenerate the hosts file because puppet agent screws it up
  ansible-playbook -i inventory  playbooks/generate_hostsfile.yml --limit puppet-node
  #modding time
  ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppet_environment_mods.yml
  #rinse and repeat
  ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT cccp_branch=$1" playbooks/puppetmaster.yml
  if [ ! $? -eq 0 ]; then exit 1; fi
fi

### this part feels unnecessary
ansible-playbook -i inventory playbooks/generate_hostsfile.yml --limit puppet-node
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT" playbooks/puppet_environment_mods.yml
ansible -m shell -i inventory -a "sudo systemctl restart puppetserver" puppet-node
###
