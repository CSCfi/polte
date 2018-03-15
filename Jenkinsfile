pipeline {
    agent any

    stages {
        stage('Build Heat stack') {
            steps {
                echo 'Building Heat stack'
                sh '''
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
                parallel("Bootstrap LDAP server": {
                    echo "LDAP"
                    sh '''
                        source ldap.sh
                    '''
                },
                "Bootstrap and puppetize puppetmaster": {
                    echo "Puppetmaster"
                    sh '''
                        source puppetmaster.sh
                    '''
                },
                "Bootstrap API nodes": {
                    echo "APIs"
                    sh '''
                        source api-pre.sh
                    '''
                })
            }
        }
        stage('Parallel backend') {
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
                })
            }
        }
        stage('Provision API and Ceph nodes') {
            steps {
                parallel("Puppetize API nodes": {
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
                })
            }
        }
        stage('Post-API actions') {
            steps {
                parallel("Post-API modifications": {
                    echo 'Deploying'
                    sh '''
                        source api-post.sh
                    '''
                },
                "Puppetize object storage nodes": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-obj.sh
                    '''
                })
            }
        }
    }
}
