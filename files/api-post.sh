#!/bin/bash +xe

#env
source ansible_shell_env.sh

virtualenv rtxt
source rtxt/bin/activate
python -m pip install -r requirements.txt

#run
ansible-playbook -i inventory playbooks/post_puppetize_apis.yml

#cleanup
if [ $? -eq 0 ]; then
#  openstack stack delete MULTIBRANCH_"$PUPPET_ENVIRONMENT"
#  rm inventory/ooo_inventory
  exit 0
fi
exit 1
