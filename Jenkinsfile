pipeline {
  agent any

  stages {

    stage('Clone Repo') {
      steps {
        git 'https://github.com/your-repo/myapp.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t <dockerhub-username>/myapp:v2 .'
      }
    }

    stage('Push Image') {
      steps {
        sh 'docker push <dockerhub-username>/myapp:v2'
      }
    }

    stage('Deploy Green') {
      steps {
        sh 'kubectl apply -f k8s/deployment-green.yaml'
      }
    }

    stage('Switch Traffic') {
      steps {
        input message: "Switch traffic to GREEN?"
        sh '''
        kubectl patch service myapp-service \
        -p '{"spec":{"selector":{"app":"myapp","color":"green"}}}'
        '''
      }
    }

  }
}
