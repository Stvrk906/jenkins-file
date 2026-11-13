pipeline {
  agent any
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'git log --oneline -3'
      }
    }

    stage('Vérification du dépôt') {
      steps {
        sh 'ls -la'
        sh 'test -f docker-compose.yml'
      }
    }

    stage('Lint') {
      steps {
        sh '''
          docker run --rm --volumes-from jenkins -w "$PWD" python:3.12-slim \
            sh -c "pip install -q yamllint ansible-lint && yamllint . && ansible-lint ansible/"
        '''
      }
    }

    stage('Build Docker') {
      steps {
        sh 'docker compose build'
        sh 'docker images | grep netdevops'
      }
    }

    stage('Trivy Scan') {
      steps {
        sh '''
          for img in web-dmz dns-lan router-fw; do
            docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v trivy-cache:/root/.cache \
              aquasec/trivy:0.57.1 image --no-progress --scanners vuln \
              --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 netdevops/$img:1.0
          done
        '''
      }
    }
  }

  post {
    success { echo 'Pipeline OK' }
    failure { echo 'Pipeline en échec' }
  }
}
