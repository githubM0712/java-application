pipeline {
    agent any

    environment {
        // Set any environment variables needed for your deployment
        DOCKER_IMAGE = '549670252733.dkr.ecr.ap-south-1.amazonaws.com/java-application'     
        ECR_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Cloning') {
            steps {
                git branch: 'main',credentialsId: 'java_repo_creds', url: 'https://github.com/githubM0712/java-application.git'
            }
        } 
           

        stage('Building Artifacts') {
            steps {
               script {
                   docker.image('maven:3.6.3-jdk-8').inside {
                     sh 'mvn clean package'
                  }
               }
           }           
        }
       
        stage('Build Docker Image') {
            steps {
               script {
                 docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")                          
          }
        }
    }


    stage('Push to ECR') {
          steps {
            script {
                 sh "aws ecr get-login-password --region ${ECR_REGION} | docker login --username AWS --password-stdin ${DOCKER_IMAGE}"
                 sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"    
                        }
    }
}

    stage('Commit to deploy') {
          steps {
            script {
               sh "sed -i 's|549670252733.dkr.ecr.ap-south-1.amazonaws.com/java-application:[0-9]*|${DOCKER_IMAGE}:${BUILD_NUMBER}|g' deployment/deployment.yaml"
               WithCredentials([usernamePassword(credentialsID: 'java_repo_creds', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
               sh ''' 
                     git config user.email "githubcloudcontainer@gmail.com"
                     git config user.name "githubM0712"
                     git add deployment/deployment.yaml
                     git commit -m "Update image to tag to ${BUILD_NUMBER}"
                     git remote set-url origin https://$GIT_PASSWORD@github.com/githubM0712/java-application.git
                     git push --set-upstream origin main
                     git push
                   '''
                    }
       }
    }
  }
 }
}


