pipeline {
   agent none 

    triggers {
        pollSCM 'H/5 * * * *'
    }

    stages {
        stage('Compile et tests') {
             agent {
                docker { 
                    image 'openjdk:8-jdk-alpine' 
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh './mvnw clean integration-test'
                archiveArtifacts 'application/target/*.jar'
                stash includes : 'application/target/*.jar', name : 'appli'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        stage('Analyse qualité') {
            agent {
                docker { 
                    image 'openjdk:8-jdk-alpine' 
                    args '-v $HOME/.m2:/root/.m2'
                }
            }       
            steps {
                echo "QUALITY ANALYSIS"
//                sh './mvnw clean verify sonar:sonar'
            }
        }
            
        stage('Building docker image') {
            // Construire et publier une image docker
            agent any
            steps {
                echo "Building docker images"
                unstash "appli"
                sh 'cp application/src/main/docker/Dockerfile application/target/ '
                script {
                    def dockerImage = docker.build('dthibau/multi-module', 'application/target')
                    docker.withRegistry('https://registry.hub.docker.com', 'dthibau_docker') {
                        dockerImage.push "build-${env.BUILD_ID}"
                    }
                }
            }
        }

     }
    
}

