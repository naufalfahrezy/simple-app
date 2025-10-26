pipeline {
  agent any
  environment {
    IMAGE_NAME = 'naufalfahrezy/simple-app'
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Unit Test') {
      steps {
        bat '''
          docker run --rm ^
            -v "%cd%":/app ^
            -w /app ^
            python:3.11-slim sh -lc "pip install -r requirements.txt && pytest -q"
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        bat "docker build -t %IMAGE_NAME%:%BUILD_NUMBER% ."
      }
    }

    stage('Tag Images') {
      steps {
        script { env.SHORT_COMMIT = env.GIT_COMMIT ? env.GIT_COMMIT.take(7) : "no-git" }
        bat "docker tag %IMAGE_NAME%:%BUILD_NUMBER% %IMAGE_NAME%:latest"
        bat "docker tag %IMAGE_NAME%:%BUILD_NUMBER% %IMAGE_NAME%:%SHORT_COMMIT%"
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          bat "echo %PASS% | docker login -u %USER% --password-stdin"
          bat "docker push %IMAGE_NAME%:%BUILD_NUMBER%"
          bat "docker push %IMAGE_NAME%:latest"
          bat "docker push %IMAGE_NAME%:%SHORT_COMMIT%"
        }
      }
    }
  }

  post {
    always {
      bat "docker logout || ver >nul"
    }
  }
}
