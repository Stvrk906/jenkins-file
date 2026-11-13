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
  }

  post {
    success { echo 'Pipeline OK' }
    failure { echo 'Pipeline en échec' }
  }
}
