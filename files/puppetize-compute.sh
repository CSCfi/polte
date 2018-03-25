#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass
if [ $? -eq 0 ]; then ssh-agent -k && exit 0; fi
ansible-playbook -i inventory playbooks/puppetize_compute.yml -e "puppet_environment=$PUPPET_ENVIRONMENT" --vault-password-file=/var/lib/jenkins/credentials/.vault_pass

#cleanup
[ $? -eq 0 ] && ssh-agent -k