# Step 2: Configure Server (Ansible)

This directory contains the Ansible playbook to install Docker, Jenkins, and kubectl on our newly provisioned EC2 instance.

## Execution Steps

1. Update the `inventory.ini` file:
   - Replace `<EC2_PUBLIC_IP>` with the actual public IP of your EC2 instance.
   - Make sure `ansible_ssh_private_key_file` points to the correct location of your `.pem` key.

2. Run the Ansible playbook to configure the server:
   ```bash
   ansible-playbook -i inventory.ini setup.yml
   ```

This step will install all necessary dependencies, start Docker, and set up Jenkins.
