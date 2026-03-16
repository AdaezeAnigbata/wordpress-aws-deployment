#!/bin/bash

# 1. Update the system packages
sudo apt update -y

# 2. Install AWS CLI (needed for backups in Task 3)
if ! command -v aws &> /dev/null; then
    sudo snap install aws-cli --classic
fi

# 3. Install Docker and Docker Compose safely
if ! command -v docker &> /dev/null; then
    sudo apt install docker.io docker-compose -y
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu
fi

# 4. Create the directory for the database
sudo mkdir -p /mnt/mysql-data

# 5. Mount the EBS volume if it is not already mounted
if ! grep -qs '/mnt/mysql-data' /proc/mounts; then
    sudo mount /dev/nvme1n1 /mnt/mysql-data
fi

# 6. Set correct permissions so Docker can save data to it
sudo chmod 777 /mnt/mysql-data

echo "Server provisioned successfully!"