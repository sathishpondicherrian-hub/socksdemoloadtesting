pipeline {
    agent any

    environment {
        IMAGE_NAME = "sathishkumarsdocker/jmeter"
        IMAGE_TAG  = "1.0"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sathishpondicherrian-hub/socksdemoloadtesting.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image') {
            steps {
                withDockerRegistry(
                    credentialsId: 'dockerhub-creds',
                    url: 'https://index.docker.io/v1/'
                ) {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Run JMeter Test') {
            steps {
                sh """
                docker volume create jmeter-results || true

                docker run --rm \
                -v jmeter-results:/results \
                ${IMAGE_NAME}:${IMAGE_TAG} \
                -n -t /test/socksproject.jmx \
                -l /results/results.jtl
                """
            }
        }

        stage('Copy Results') {
            steps {
                sh '''
                mkdir -p reports

                docker run --rm \
                -v jmeter-results:/from \
                -v $(pwd)/reports:/to \
                alpine sh -c "cp /from/results.jtl /to/"
                '''
            }
        }

        stage('Archive Results') {
            steps {
                archiveArtifacts artifacts: 'reports/**',
                                 fingerprint: true,
                                 allowEmptyArchive: true
            }
        }

        stage('Clean Docker Images') {
            steps {
                sh 'docker image prune -f'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }

        failure {
            echo 'Pipeline failed'
        }
    }
}
