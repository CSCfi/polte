#!/bin/bash +xe

#prereq variables for secrets export
cp /var/lib/jenkins/credentials/vault-all.yml inventory/group_vars/all/vault.yml
ansible localhost -m template -a "src=files/ansible_shell_env.sh dest=." -e @inventory/group_vars/all/vault.yml  --vault-password-file=/tmp/.tmp_vault_pass
source ansible_shell_env.sh

#ssh dir
mkdir -p .ssh/cm_socket

#ansible roles
mkdir -p roles
ansible-galaxy install -r requirements.yml --roles-path roles/

#run
ansible-playbook -i inventory -e "puppet_environment=$PUPPET_ENVIRONMENT heat_stack_name=MULTIBRANCH_ceph_ansible_stable_4_0" playbooks/build-heat-stack.yml
