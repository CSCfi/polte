#!/bin/bash
#
# For verifying that using the Jenkinsfile does not introduce any
# weird variable dependencies i.e. that the same stack can be built
# with standalone bash scripts.

echo "export PUPPET_ENVIRONMENT=cccp_master_cpouta" > puppet_env.sh
cp files/*.sh .

# Build heat stack
source build.sh

# Generate hosts file, reboot to enforce openstacklocal domain
source hosts.sh

# Install and configure LDAP server
source ldap.sh

# Bootstrap and puppetize puppetmaster
source puppetmaster.sh master

# Puppetize backend nodes
source puppetize-backend.sh

# Puppetize API nodes
HOSTLIMIT="api-node0,api-node0" source puppetize-api.sh

# Build Ceph cluster
source ceph-ansible.sh

# Puppetize compute nodes
source puppetize-compute.sh

# Puppetize obj nodes
source puppetize-obj.sh

# Puppetize net nodes
source puppetize-net.sh

# Post puppetize actions
source api-post.sh
