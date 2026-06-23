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

        stage('Validate Files') {
            steps {
                sh '''
                ls -l
                test -f Dockerfile
                test -f socksproject.jmx
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Push Image') {
            steps {
                withDockerRegistry(
                    credentialsId: 'dockerhub-creds',
                    url: 'https://index.docker.io/v1/'
                ) {
                    sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
                }
            }
        }

        stage('Run JMeter Test') {
            steps {
                sh '''
                mkdir -p reports

                docker run --rm \
                -v $PWD/reports:/test/reports \
                ${IMAGE_NAME}:${IMAGE_TAG} \
                -n \
                -t /test/socksproject.jmx \
                -l /test/reports/results.jtl
                '''
            }
        }

        stage('Archive Results') {
            steps {
                archiveArtifacts artifacts: 'reports/**', fingerprint: true
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

        always {
            sh 'docker image prune -f || true'
        }
    }
}
