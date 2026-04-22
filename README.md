# Blue-Green Deployment Lab

This repository contains an end-to-end execution-ready workflow for a Blue-Green deployment architecture. 

## Final Architecture Flow
1. **Terraform** → provisions AWS EC2 instance
2. **Ansible** → configures runtime environment (Docker, Jenkins, kubectl)
3. **Docker** → containerizes application (Blue and Green versions)
4. **Kubernetes** → manages Blue & Green deployments using Minikube
5. **Jenkins** → automates CI/CD pipeline
6. **Service selector** → controls traffic routing between Blue and Green

---

## Step 1: Provision Infrastructure (Terraform → AWS EC2)

This provisions the necessary AWS EC2 instance for our lab.

### Prerequisites
- Terraform installed
- AWS credentials configured locally
- SSH Key Pair (`your-keypair.pem`) exists in your AWS account

### Execution Steps
1. Navigate to the terraform directory and initialize it:
   ```bash
   cd terraform
   terraform init
   ```
2. Review and apply the configuration to create the EC2 instance:
   ```bash
   terraform apply -auto-approve
   ```
3. **IMPORTANT**: Note down the **Public IP** of the created EC2 instance from the AWS console (or Terraform output if configured). You will need this for the next step.
4. Return to the root directory:
   ```bash
   cd ..
   ```

---

## Step 2: Configure Server (Ansible)

This installs Docker, Jenkins, and kubectl on our newly provisioned EC2 instance.

Target OS: Amazon Linux 2023 (AMI `ami-098e39bafa7e7303d`)

### Execution Steps
1. Update the `ansible/inventory.ini` file:
   - Replace `<EC2_PUBLIC_IP>` with the actual public IP of your EC2 instance.
   - Keep `ansible_user=ec2-user` for Amazon Linux 2023.
   - Make sure `ansible_ssh_private_key_file` points to the correct location of your `.pem` key.

2. Run the Ansible playbook to configure the server:
   ```bash
   cd ansible
   ansible-playbook -i inventory.ini setup.yml
   cd ..
   ```

---

## Step 3: Prepare Application (Docker)

This step builds our sample application.

### Build Blue Version (v1)
1. Ensure `app/index.html` contains:
   ```html
   <h1>Blue Version</h1>
   ```
2. Build and push the image to DockerHub (replace `<dockerhub-username>` with your actual username):
   ```bash
   cd app
   docker build -t <dockerhub-username>/myapp:v1 .
   docker push <dockerhub-username>/myapp:v1
   ```

### Build Green Version (v2)
1. Modify the `app/index.html` file to say:
   ```html
   <h1>Green Version</h1>
   ```
2. Build and push the updated image:
   ```bash
   docker build -t <dockerhub-username>/myapp:v2 .
   docker push <dockerhub-username>/myapp:v2
   cd ..
   ```

---

## Step 4: Install Kubernetes (Minikube on EC2)

1. SSH into your EC2 instance:
   ```bash
   ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
   ```
2. Install Minikube and start the cluster:
   ```bash
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube

   minikube start --driver=docker
   ```
3. Verify the installation:
   ```bash
   kubectl get nodes
   ```

---

## Step 5: Kubernetes Deployments

Before running the apply commands, make sure you are in the project directory on the EC2 instance (or use absolute paths to the manifest files).

Example:
```bash
git clone <your-repo-url> blue-green-lab
cd blue-green-lab
```

### 1. Deploy Blue Environment
Apply the blue deployment and the service:
```bash
kubectl apply -f k8s/deployment-blue.yaml
kubectl apply -f k8s/service.yaml
```

Verify it is running and access the app:
```bash
kubectl get pods
kubectl get svc
minikube service myapp-service
```

### 2. Deploy Green Environment (Parallel)
Deploy the green version. It will run idle alongside blue, but won't receive traffic yet.
```bash
kubectl apply -f k8s/deployment-green.yaml
```

### 3. Traffic Switch (Blue -> Green)
To instantly route traffic to the Green deployment with zero downtime:
```bash
kubectl patch service myapp-service \
-p '{"spec":{"selector":{"app":"myapp","color":"green"}}}'
```

### 4. Verification & Rollback
Verify the running pods and test via browser:
```bash
kubectl get pods -L color
```

If you need to rollback to the Blue version:
```bash
kubectl patch service myapp-service \
-p '{"spec":{"selector":{"app":"myapp","color":"blue"}}}'
```

---

## Step 6: Jenkins Pipeline Setup

1. Open Jenkins in your browser at `http://<EC2_PUBLIC_IP>:8080`.
2. Install the **Docker Pipeline** and **Kubernetes CLI** plugins.
3. Add your credentials for **DockerHub** and optionally **SSH**.
4. Create a new Pipeline job and configure it to use the `Jenkinsfile` from this repository.
