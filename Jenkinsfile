pipeline {
    agent any

    stages {
        stage('Build Heat stack') {
            steps {
                echo 'Building Heat stack'
                sh '''
                    mkdir -p .ssh/cm_socket
                    cp /tmp/buildscripts/*.sh .
                    echo "export PUPPET_ENVIRONMENT=cccp_master_cpouta" > puppet_env.sh
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
                parallel("Puppetize backend": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-backend.sh
                    '''
                },
                "Regenerate hostsfile": {
                    echo 'Generating hostsfile'
                    sh '''
                        source hosts.sh
                    '''
                },
                "Puppetmaster mods": {
                    echo "Modifying puppet envs"
                    sh '''
                        source puppet-env-mods.sh
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
        stage('Puppetize object storage nodes') {
            steps {
                echo 'Puppetizing'
                sh '''
                    source puppetize-obj.sh
                '''
            }
        }
        stage('Post-puppetize actions') {
            steps {
                echo 'Deploying'
                sh '''
                    source api-post.sh
                '''
            }
        }
    }
}
