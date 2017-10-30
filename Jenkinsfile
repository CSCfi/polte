pipeline {
    agent any

    stages {
        stage('Build Heat stack') {
            steps {
                echo 'Building Heat stack'
                sh '''
                    cp /tmp/quest_of_the_sacred_baboon/*.sh .
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
                "Bootstrap puppetmaster": {
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
        stage('Regenerate hostsfile') {
            steps {
                echo 'Generating hostsfile'
                sh '''
                    source hosts.sh
                '''
            }
        }
        stage('Parallel puppetize') {
            steps {
                parallel("Puppetize backend": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-backend.sh
                    '''
                },
                "Puppetize APIs": {
                    echo 'Puppetizing'
                    sh '''
                        source puppetize-api.sh
                        source puppetize-api.sh
                        source puppetize-api.sh
                        source puppetize-api.sh
                        source puppetize-api.sh
                    '''
                })
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
