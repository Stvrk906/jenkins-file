   pipeline {
       agent any

       stages {
           stage('Checkout Git') {
               steps {
                   echo 'Pulling...'
                   checkout scm
               }
           }

           stage('Date systeme') {
               steps {
                   sh 'date'
               }
           }
       }
   }
