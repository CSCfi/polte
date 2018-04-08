#!/bin/bash +xe

#env
source ansible_shell_env.sh

#prereq
ansible -m shell -a "sudo yum install -y centos-release-ceph-jewel" -i inventory "mons,osds" --vault-password-file="$VAULT_PASS_FILE"
cp /var/lib/jenkins/credentials/vault-mons.yml inventory/group_vars/mons/vault.yml

#run
cd playbooks
rm -Rf ceph-ansible
git clone https://github.com/ceph/ceph-ansible.git
cd ceph-ansible
git checkout v3.1.0beta3
cp ../../ssh.config .
cp ../../ansible.cfg .
ln -s ../../.ssh
mkdir -p fetch/12345678-90ab-cdef-1234-567890abcdef/etc/ceph
echo "12345678-90ab-cdef-1234-567890abcdef" > fetch/ceph_cluster_uuid.conf
ansible-playbook -i ../../inventory --vault-password-file="$VAULT_PASS_FILE" --limit "mons,osds" site.yml.sample
