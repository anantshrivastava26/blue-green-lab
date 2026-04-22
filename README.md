# Blue-Green Deployment Lab

This repository contains an end-to-end execution-ready workflow for a Blue-Green deployment architecture. 

## Final Architecture Flow
1. **Terraform** → provisions AWS EC2 instance
2. **Ansible** → configures runtime environment (Docker, Jenkins, kubectl)
3. **Docker** → containerizes application (Blue and Green versions)
4. **Kubernetes** → manages Blue & Green deployments using Minikube
5. **Jenkins** → automates CI/CD pipeline
6. **Service selector** → controls traffic routing between Blue and Green

## Execution Sequence

Please follow the step-by-step instructions in each directory's README in the following order:

1. **[Terraform Provisioning](./terraform/README.md)**: Set up the AWS EC2 instance.
2. **[Ansible Configuration](./ansible/README.md)**: Install necessary dependencies on the EC2 instance.
3. **[Application Build](./app/README.md)**: Containerize and push the app versions to DockerHub.
4. **[Kubernetes Deployment](./k8s/README.md)**: Set up Minikube and deploy the applications.
5. **[Jenkins Automation (Optional)](#jenkins-pipeline)**: Configure a CI/CD pipeline using the `Jenkinsfile` in the root.

## Jenkins Pipeline Setup

1. Open Jenkins in your browser at `http://<EC2_PUBLIC_IP>:8080`.
2. Install the **Docker Pipeline** and **Kubernetes CLI** plugins.
3. Add your credentials for **DockerHub** and optionally **SSH**.
4. Create a new Pipeline job and configure it to use the `Jenkinsfile` from this repository.
