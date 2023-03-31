def version = new Date().format("yyyyMMddHHmmss")
pipeline {
    agent any
    stages {
        stage('checkout github repositoy') {
            steps {
                echo 'pulling';
                git branch:'main',url : 'https://github.com/rihabhan/pfa2devops.git';
            }
        }
        stage('build Maven ') {
            steps {
               
                sh 'mvn clean install'
            }
        }
        stage('RUN tests') {
            parallel {
                  stage('Unit test ') {
            steps {
               
                sh 'mvn test'
            }
        }
          stage('Sonarqube Analysis ') {
            steps {
                withSonarQubeEnv('sonarqube-8.9.7'){
                sh 'mvn sonar:sonar'
                }
                }
            }
            
        }
               
                
            }
        stage('Artifact deploy to Nexus ') {
            steps {
               nexusArtifactUploader artifacts: [[
                   artifactId: 'ExamThourayaS2',
                   classifier: '',
                   file: 'target/ExamThourayaS2-0.0.1.jar',
                   type: 'jar']],
                   credentialsId: 'nexus',
                   groupId: 'tn.esprit',
                   nexusUrl: '192.168.1.39:8081',
                   nexusVersion: 'nexus3',
                   protocol: 'http',
                   repository: 'springapp-release',
                   version: "${version}"
            }
        }
        stage('Docker image '){
            steps {
                 sh 'docker build -t rihabhn/backendappimage .'
            }
        }
        stage('push to DockerHub'){
            steps { 
		        withCredentials([usernamePassword(credentialsId: 'dockerhubdev', passwordVariable: 'PASSWORD', usernameVariable: 'USER')])
		        {
                    sh 'docker login -u ${USER} -p ${PASSWORD}'
                    sh 'docker push rihabhn/backendappimage'
                    
                }
       }
       }
        stage('DockerCompose') {
        
            steps {
				    sh 'docker-compose up -d'
                    }
                          
        }
        stage('Notify') {
            steps {
                script {
                    slackSend (color: '#36a64f', message: 'The build has completed successfully', tokenCredentialId: 'slack', channel: 'pfa')
                        }
                    }
        }
        
        
    }
}
