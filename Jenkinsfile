pipeline {
    agent any

    parameters {
        string(
            name: 'CCCP_BRANCH',
            defaultValue: 'master',
            description: 'CCCP feature branch')
    }

    stages {
        stage('Build Heat stack') {
            steps {
                echo 'Building Heat stack'
                sh '''
                    mkdir -p .ssh/cm_socket
                    echo "export PUPPET_ENVIRONMENT=epouta" > puppet_env.sh
                    cp files/*.sh .
                    source build.sh
                '''
            }
        }
        stage('Generate hostsfile') {
            steps {
                echo 'Generating hostsfile'
                sh '''
                    source hosts.sh
                '''
            }
        }
        stage('Parallel bootstrap') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') != 0
                }
            }
            steps {
                parallel("Ansiblize LDAP server": {
                    echo "LDAP"
                    sh '''
                        source ldap.sh
                    '''
                },
                "Puppetize puppetmaster and apply mods": {
                    echo "Puppetmaster"
                    sh "source puppetmaster.sh \"${CCCP_BRANCH}\""
                })
            }
        }
        stage('Parallel backend and primary frontend') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') != 0
                }
            }
            steps {
                parallel("Puppetize backend nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-backend.sh
                    '''
                },
                "Puppetize network nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-net.sh
                    '''
                },
                "Puppetize primary API node": {
                    echo 'Puppetizing'
                    sh '''
                        HOSTLIMIT=api-node0 source puppetize-api.sh
                    '''
                },
                "Ansiblize Ceph nodes": {
                    echo 'Ansiblizing'
                    sh '''
                        source ceph-ansible.sh
                    '''
                })
            }
        }
        stage('Parallel frontends and compute and object') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') != 0
                }
            }
            steps {
                parallel("Puppetize secondary API node": {
                    echo 'Puppetizing'
                    sh '''
                        HOSTLIMIT=api-node1 source puppetize-api.sh
                    '''
                },
                "Puppetize compute nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-compute.sh
                    '''
                })
            }
        }
        stage('Cleanup and Horizon mods') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') != 0
                }
            }
            steps {
                echo 'Post-API Horizon modifications'
                sh '''
                    source api-post.sh
                '''
            }
        }
        stage('Stage APIs') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') == 0
                }
            }
            steps {
                echo 'Stage APIs'
                sh "source upgrade_api_pre.sh"
            }
        }
        stage('Stage queens code') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') == 0
                }
            }
            steps {
                echo 'Puppetize puppetmaster with queens hiera and queens cccp'
                sh '''
                    echo "export PUPPET_ENVIRONMENT=cccp_queens_master_epouta" > puppet_env.sh
                    source puppetmaster.sh queens/master
                '''
            }
        }
        stage('Upgrade APIs') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') == 0
                }
            }
            steps {
                echo 'Puppetize APIs with queens'
                sh '''
                    HOSTLIMIT=api source puppetize-api.sh
                '''
            }
        }
        stage('API post-puppetize steps') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') == 0
                }
            }
            steps {
                echo 'API post-puppetize'
                sh "source upgrade_api_post.sh"
            }
        }
        stage('Parallel upgrade compute and the rest') {
            when {
                expression {
                    sh(returnStatus: true, script: '/bin/bash ansible_shell_env.sh;ansible-playbook -i inventory playbooks/check_post_done.yml') == 0
                }
            }
            steps {
                parallel("Upgrade compute nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source upgrade_compute.sh
                    '''
                },
                "API round 2": {
                    echo 'Puppetize APIs with queens'
                    sh '''
                        HOSTLIMIT=api source puppetize-api.sh
                    '''
                },
                "Upgrade backend nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-backend.sh
                    '''
                },
                "Upgrade object nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-obj.sh
                    '''
                },
                "Upgrade net nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-net.sh
                    '''
                })
            }
        }
    }
}
