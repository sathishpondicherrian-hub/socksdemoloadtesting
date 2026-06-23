pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/sathishpondicherrian-hub/socksdemoloadtesting.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t sathishkumarsdocker/jmeter:1.0 .
                '''
            }
        }

        stage('Push Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds']) {
                    sh 'docker push sathishkumarsdocker/jmeter:1.0'
                }
            }
        }

    }
}
