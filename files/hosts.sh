#!/bin/bash +xe

#env
source ansible_shell_env.sh

#run
ansible-playbook -i inventory playbooks/generate_hostsfile.yml
