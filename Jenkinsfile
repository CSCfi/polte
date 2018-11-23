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
                    echo "export PUPPET_ENVIRONMENT=dummy_string" > puppet_env.sh
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
        stage('Parallel backend and frontend') {
            steps {
                parallel("Ansiblize Ceph nodes": {
                    echo 'Ansiblizing'
                    sh '''
                        source ceph-ansible.sh
                    '''
                })
            }
        }
    }
}
