pipeline {
    agent any 
    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select The Environment')
    }
    options {
        ansiColor('xterm')    // Add's color to the output : Ensure you install AnsiColor Plugin.
    }
    stages {

        //  stage('Backend') {
        //     parallel {
        //        stage('Destroying-User') {
        //            steps {
        //                dir('USER') {  git branch: 'main', url: 'https://github.com/b51-clouddevops/user.git'
        //                   sh '''
        //                     cd tf-mutable
        //                     terrafile -f env-${ENV}/Terrafile
        //                     terraform init -backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure
        //                     terraform destroy -var-file=env-${ENV}/${ENV}.tfvars  -var APP_VERSION=0.0.2 -auto-approve
        //                   '''
        //                     }
        //                 }
        //            }
        //        stage('Destroying-Catalogue') {
        //            steps {
        //                dir('Catalogue') {  git branch: 'main', url: 'https://github.com/b51-clouddevops/catalogue.git'
        //                   sh '''
        //                     cd tf-mutable
        //                     terrafile -f env-${ENV}/Terrafile
        //                     terraform init -backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure
        //                     terraform destroy -var-file=env-${ENV}/${ENV}.tfvars  -var APP_VERSION=0.0.3 -auto-approve
        //                   '''
        //                     }
        //                 }
        //           }
        //     stage('Destroying-Payment') {
        //         steps {
        //             dir('PAYMENT') {  git branch: 'main', url: 'https://github.com/b51-clouddevops/payment.git'
        //                   sh '''
        //                     cd tf-mutable
        //                     terrafile -f env-${ENV}/Terrafile
        //                     terraform init -backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure
        //                     terraform destroy -var-file=env-${ENV}/${ENV}.tfvars  -var APP_VERSION=0.0.2 -auto-approve
        //                   '''
        //                  }
        //              }
        //         }
        //     stage('Destroying-Cart') {
        //         steps {
        //             dir('CART') {  git branch: 'main', url: 'https://github.com/b51-clouddevops/cart.git'
        //                   sh '''
        //                     cd tf-mutable
        //                     terrafile -f env-${ENV}/Terrafile
        //                     terraform init -backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure
        //                     terraform destroy -var-file=env-${ENV}/${ENV}.tfvars  -var APP_VERSION=0.0.2 -auto-approve
        //                   '''
        //                  }
        //              }
        //         }
        //     stage('Destroying-Shipping') {
        //         steps {
        //             dir('SHIPPING') {  git branch: 'main', url: 'https://github.com/b51-clouddevops/shipping.git'
        //                   sh '''
        //                     cd tf-mutable
        //                     terrafile -f env-${ENV}/Terrafile
        //                     terraform init -backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure
        //                     terraform destroy -var-file=env-${ENV}/${ENV}.tfvars  -var APP_VERSION=0.0.1  -auto-approve
        //                   '''
        //                  }
        //              }
        //         }
        //      } 
        //   }
        //     stage('Destroying-Frontend') {
        //         steps {
        //             dir('FRONTEND') {  git branch: 'main', url: 'https://github.com/b51-clouddevops/frontend.git'
        //                   sh '''
        //                     cd tf-mutable
        //                     terrafile -f env-${ENV}/Terrafile
        //                     terraform init -backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure
        //                     terraform destroy -var-file=env-${ENV}/${ENV}.tfvars  -var APP_VERSION=0.0.3 -auto-approve
        //                   '''
        //                  }
        //              }
        //         } 

        stage('Terraform Destroy Databses') {
            steps {
                git branch: 'main', url: 'https://github.com/bohrapankajs/terrform-databases.git'
                sh "terrafile -f env-${ENV}/Terrafile"
                sh "terraform init --backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure"
                sh "terraform plan -var-file=env-${ENV}/${ENV}.tfvars"
                sh "terraform destroy -var-file=env-${ENV}/${ENV}.tfvars -auto-approve"
            }
        }

        stage('Terraform Destroy ALB') {
            steps {
                git branch: 'main', url: 'https://github.com/b51-clouddevops/terraform-loadbalancers.git'
                sh "terrafile -f env-${ENV}/Terrafile"
                sh "terraform init --backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure"
                sh "terraform plan -var-file=env-${ENV}/${ENV}.tfvars"
                sh "terraform destroy -var-file=env-${ENV}/${ENV}.tfvars -auto-approve"
            }
        }

        stage('Terraform Destroy Network') {
            steps {
                git branch: 'main', url: 'https://github.com/bohrapankajs/terraform-vpc.git'
                sh "terrafile -f env-${ENV}/Terrafile"
                sh "terraform init --backend-config=env-${ENV}/${ENV}-backend.tfvars -reconfigure -reconfigure"
                sh "terraform plan -var-file=env-${ENV}/${ENV}.tfvars"
                sh "terraform destroy -var-file=env-${ENV}/${ENV}.tfvars -auto-approve"
            }
        }
    }
}