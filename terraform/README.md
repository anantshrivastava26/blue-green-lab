# Step 1: Provision Infrastructure (Terraform → AWS EC2)

This directory contains the Terraform configuration to provision the necessary AWS EC2 instance for our lab.

## Prerequisites
- Terraform installed
- AWS credentials configured locally
- SSH Key Pair (`your-keypair.pem`) exists in your AWS account

## Execution Steps

1. Initialize Terraform to download the required provider plugins:
   ```bash
   terraform init
   ```

2. Review and apply the configuration to create the EC2 instance:
   ```bash
   terraform apply -auto-approve
   ```

3. **IMPORTANT**: Note down the **Public IP** of the created EC2 instance from the AWS console (or Terraform output if configured). You will need this for the next step.
