#!/bin/bash +xe

#prereq variables for secrets export
ansible-vault decrypt files/ansible_shell_env.sh.vault --output=ansible_shell_env.sh --vault-password-file=/tmp/.tmp_vault_pass
source ansible_shell_env.sh

#ssh agent
mkdir -p .ssh/cm_socket
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#ansible roles
mkdir -p roles
ansible-galaxy install -r requirements.yml --roles-path roles/

#run
ansible-playbook playbooks/build-heat-stack.yml \
-i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT heat_stack_name=MULTIBRANCH_$PUPPET_ENVIRONMENT"

#cleanup
[ $? -eq 0 ] && ssh-agent -k
