pipeline {
    agent any

    stages {
        stage('Build Heat stack') {
            steps {
                echo 'Building Heat stack'
                sh '''
                    source build.sh
                '''
            }
        }
        stage('Enforce hostsfile') {
            steps {
                echo 'Generating hostsfile'
                sh '''
                    source hosts.sh
                '''
            }
        }
        stage('Parallel actions') {
            steps {
                parallel("Bootstrap LDAP server": {
                    echo "LDAP"
                },
                "Bootstrap puppetmaster": {
                    echo "Puppetmaster"
                },
                "Bootstrap API nodes": {
                    echo "APIs"
                })
            }
        }
        stage('Puppetize backend') {
            steps {
                echo 'Puppetizing'
            }
        }
        stage('Puppetize APIs') {
            steps {
                echo 'Puppetizing'
            }
        }
        stage('Post-puppetize actions') {
            steps {
                echo 'Deploying'
            }
        }
    }
}
