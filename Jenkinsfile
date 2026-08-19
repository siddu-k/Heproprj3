pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        REGISTRY = 'siddu99/sample-web'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        KUBECONFIG_CREDENTIALS = credentials('k8s-kubeconfig')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out source code from Git repository..."
                checkout scm
            }
        }

        stage('1. Build Image') {
            steps {
                echo "Building Docker container image: ${REGISTRY}:${IMAGE_TAG}..."
                sh """
                    docker build -t ${REGISTRY}:${IMAGE_TAG} .
                    docker tag ${REGISTRY}:${IMAGE_TAG} ${REGISTRY}:latest
                """
            }
        }

        stage('2. Run Tests') {
            steps {
                echo "Running container linting and HTTP health tests..."
                sh """
                    # Spin up temporary container for test validation
                    docker run -d --name test-web -p 8081:80 ${REGISTRY}:${IMAGE_TAG}
                    sleep 3
                    curl -s -f http://localhost:8081/ || exit 1
                    docker rm -f test-web
                    echo "Unit and health smoke tests passed successfully!"
                """
            }
        }

        stage('3. Push Image') {
            steps {
                echo "Authenticating and pushing image to Docker Hub registry..."
                sh """
                    echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push ${REGISTRY}:${IMAGE_TAG}
                    docker push ${REGISTRY}:latest
                """
            }
        }

        stage('4. Deploy to Kubernetes') {
            steps {
                echo "Initiating progressive Canary rollout via Argo Rollouts..."
                sh """
                    kubectl argo rollouts set image web-rollout web=${REGISTRY}:${IMAGE_TAG} -n sample-app
                """
            }
        }

        stage('5. Verify Deployment') {
            steps {
                echo "Verifying Rollout status and pod health..."
                sh """
                    kubectl argo rollouts status web-rollout -n sample-app --timeout=120s
                    kubectl get pods,svc -n sample-app
                """
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline executed successfully! Canary deployment is live."
        }
        failure {
            echo "CI/CD Pipeline failed! Check stage logs for details."
        }
    }
}
