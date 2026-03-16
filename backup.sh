#!/bin/bash

# 1. Set the backup file name with a timestamp
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_FILE="backup-${TIMESTAMP}.sql"
BUCKET_NAME="wordpress-backup-adaeze-2026"

# 2. Run mysqldump inside the Docker container to backup the database
sudo docker-compose exec -T db mysqldump -u wp_user -pwp_secure_pass123 wordpress_db > $BACKUP_FILE

# 3. Upload the backup file to your S3 bucket
aws s3 cp $BACKUP_FILE s3://$BUCKET_NAME/

# 4. Print confirmation message
echo "Success! Backup uploaded to s3://$BUCKET_NAME/$BACKUP_FILE"