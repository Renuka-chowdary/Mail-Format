#!/bin/bash

s3_bucket=backup-hi
Now=$(date +%d-%m-%Y)
year=$(date +%Y)
month=$(date +%m)
date=$(date +%d)
time=$(date +%H:%M:%S)

echo "This is an automated daily email notification for Gitlab/Sonar/Jenkins backup and uploaded to s3 bucket on $Now at $time UTC 

Backup Data Info:
Gitlab : $(aws s3 ls --summarize --human-readable --recursive s3://backup-hi/Backups/Gitlab/2018/02/21/gitlab-backup-21-02-18 | awk '{print $3,$4}' | head -1)
Jenkins : $(aws s3 ls --summarize --human-readable --recursive s3://backup-hi/Backups/Jenkins/daily/2018/02/21/jenkins-21-02-18 | awk '{print $3,$4}' | head -1)
Sonar : $(aws s3 ls --summarize --human-readable --recursive s3://backup-hi/Backups/Sonar/daily/2018/02/21/sonar-backup-files-21-02-18 | awk '{print $3,$4}' | head -1)

Regards,
Devops" | mail -s "Gitlab/Jenkins/Sonar - Daily Auto Backup Success" -a "From: admin@hashedin.com" renuka.c@hashedin.com

~

