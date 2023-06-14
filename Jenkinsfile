pipeline {
     agent any 
    environment {
        SSH_CRED = credentials('SSH_CRED')
    }
    stages {
        stage('Parallel Stage') {
            steps {
                sh "ansible-playbook robot-dryrun.yml -e ansible_user=centos -e ansible_password=DevOps321 -e COMPONENT=mongodb -e ENV=dev"

            }
        }

    }   
}