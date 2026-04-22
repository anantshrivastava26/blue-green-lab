# Step 4 & 5: Kubernetes Deployments

This directory contains the Kubernetes manifests required to run our Blue-Green deployment architecture.

## Setup Minikube (On EC2)

1. SSH into your EC2 instance:
   ```bash
   ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
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

## Deploy Applications

### 1. Deploy Blue Environment
Apply the blue deployment and the service:
```bash
kubectl apply -f deployment-blue.yaml
kubectl apply -f service.yaml
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
kubectl apply -f deployment-green.yaml
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
