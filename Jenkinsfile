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
                echo "Testing: ${CCCP_BRANCH}"
                sh '''
                    echo "export PUPPET_ENVIRONMENT=cccp_master_epouta" > puppet_env.sh
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
        stage('Parallel backend and frontend') {
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
                "Puppetize API nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-api.sh
                    '''
                },
                "Ansiblize Ceph nodes": {
                    echo 'Ansiblizing'
                    sh '''
                        source ceph-ansible.sh
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
            steps {
                echo 'Post-API Horizon modifications'
                sh '''
                    source api-post.sh
                '''
            }
        }
    }
}
