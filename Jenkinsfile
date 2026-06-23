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
        -v $(pwd)/reports:/test/reports \
        ${IMAGE_NAME}:${IMAGE_TAG} \
        -n -t /test/socksproject.jmx \
        -l /test/reports/results.jtl

        echo "===== Workspace ====="
        pwd

        echo "===== Reports folder ====="
        ls -la reports

        echo "===== Search results.jtl ====="
        find . -name "*.jtl"
        '''
    }
}
    

        stage('Archive Results') {
            steps {
                archiveArtifacts artifacts: 'reports/**', fingerprint: true
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
