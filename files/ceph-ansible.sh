#!/bin/bash +xe

#env
source ansible_shell_env.sh

#ceph-ansible version
# stable-3.0 Supports Ceph versions jewel and luminous. This branch requires Ansible version 2.4. DEPRECATED
# stable-3.1 Supports Ceph versions luminous and mimic. This branch requires Ansible version 2.4. DEPRECATED
# stable-3.2 Supports Ceph versions luminous and mimic. This branch requires Ansible version 2.6.
# stable-4.0 Supports Ceph version nautilus. This branch requires Ansible version 2.8.
# stable-5.0 Supports Ceph version octopus. This branch requires Ansible version 2.9.
# master Supports the master branch of Ceph. This branch requires Ansible version 2.9.
export CEPH_ANSIBLE_REF="stable-4.0"

# setup virtualenv
virtualenv --python /usr/bin/python ansible2.9
source ansible2.9/bin/activate
python -m pip install 'setuptools<45.0.0'
python -m pip install 'ansible<2.10'
python -m pip install 'notario>=0.0.13'
python -m pip install 'netaddr'


#prereq
ansible -m shell -a "sudo yum install -y centos-release-ceph-nautilus" -i inventory "mons,osds,mgrs" --vault-password-file="$VAULT_PASS_FILE"
cp /var/lib/jenkins/credentials/vault-mons.yml inventory/group_vars/mons/vault.yml
cp /var/lib/jenkins/credentials/vault-osds.yml inventory/group_vars/osds/vault.yml

#prerun
cd playbooks
rm -Rf ceph-ansible
git clone https://github.com/ceph/ceph-ansible.git
cd ceph-ansible
git checkout $CEPH_ANSIBLE_REF
cp ../../ssh.config .
cat ../../ansible.cfg >> ansible.cfg
ln -s ../../.ssh
ln -s ../../inventory
mkdir -p fetch/12345678-90ab-cdef-1234-567890abcdef/etc/ceph
echo "12345678-90ab-cdef-1234-567890abcdef" > fetch/ceph_cluster_uuid.conf

#until ephemeral vfat possibly gets sorted
ansible -m shell -a 'sudo umount /mnt' -i inventory osds
ansible -m shell -a '/sbin/blkid /dev/vdb1|grep vfat && sudo dd if=/dev/zero of=/dev/vdb bs=512 count=1' -i inventory osds
ansible -m shell -a '/sbin/blkid /dev/vdb1|grep vfat && sudo dd if=/dev/zero of=/dev/vdb bs=512 count=34 seek=$(($(sudo blockdev --getsz /dev/vdb) - 34))' -i inventory osds

#run
ansible-playbook -i inventory --vault-password-file="$VAULT_PASS_FILE" --limit "mons,osds,mgrs" site.yml.sample
if [ $? -ne 0 ]; then
  ansible-playbook -i inventory --vault-password-file="$VAULT_PASS_FILE" --limit "mons,osds,mgrs" site.yml.sample
fi
