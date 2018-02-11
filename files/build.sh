#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ssh agent
ssh-agent -k
eval $(ssh-agent -s)
ssh-add "$OS_KEY_FILE"

#run
ansible-playbook playbooks/build-heat-stack.yml \
-i inventory \
-e "puppet_environment=$PUPPET_ENVIRONMENT heat_stack_name=MULTIBRANCH_$PUPPET_ENVIRONMENT" \
--vault-password-file="$VAULT_PASS_FILE"

#cleanup
[ $? -eq 0 ] && ssh-agent -k

