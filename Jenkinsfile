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
                    echo "export PUPPET_ENVIRONMENT=cccp_master_cpouta" > puppet_env.sh
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
        stage('Puppetize backend') {
            steps {
                echo 'Puppetize backend nodes'
                sh '''
                    source puppetize-backend.sh
                '''
            }
        }
        stage('Parallel backend and primary frontend') {
            steps {
                parallel("Puppetize network nodes": {
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
        stage('Parallel secondary frontend and compute') {
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
        stage('Parallel frontends and object') {
            steps {
                parallel("Puppetize both API nodes": {
                    echo 'Puppetizing'
                    sh '''
                        HOSTLIMIT=api source puppetize-api.sh
                    '''
                },
                "Puppetize object nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-obj.sh
                    '''
                })
            }
        }
        stage('Cleanup and Horizon mods') {
            steps {
                echo 'Post-API Horizon modifications'
                sh '''
                    source api-post.sh
                '''
            }
        }
    }
}
