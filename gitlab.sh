#!/bin/bash

#Updating the system
echo "Update the system........................................”
sudo apt-get update

#Installing dependencies – postfix
echo "Installing postfix........................................”
#sudo debconf-set-selections <<< 'postfix postfix/mailname string git.hashedin.com'
#sudo debconf-set-selections <<< 'postfix postfix/main_mailer_type string "Internet Site"'
sudo apt-get  install postfix

#Installing gitlab
echo "Installing gitlab........................................”
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt-get install gitlab-ce
sudo apt-get update
sudo apt-get upgarde

#Redis
echo "Installing Redis........................................”
sudo apt-get update 
sudo apt-get  install redis-tools

#RDS
echo "Installing Postgresql........................................”
sudo apt-get update 
sudo  apt-get install postgresql postgresql-contrib



#NFS
echo "Installing NFS........................................”
sudo apt-get update 
sudo apt-get install nfs-kernel-server

#Copying backup files from s3
echo "copying files from s3 to ec2 ........................................” 
sudo apt install awscli
aws s3 cp s3://backup-hi/daily/git-backup.tar.gz new/ /home/ubuntu –-recursive
aws s3 cp s3://backup-hi/daily/git-database.tar.gz new/ /home/ubuntu –-recursive

#Extracting tar files
echo "Extracting .tar files ........................................” 
sudo tar -xvf git-backup.tar.gz
sudo tar -xvf git-databse.tar.gz

#Mounting  EFS
echo “Mounting EFS ............................................”
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-c52e568c.efs.us-east-1.amazonaws.com:/renuka /var/opt/gitlab/git-data/repositories

#Mounting EFS at reboot 
echo “Mounting EFS at reboot............................................”
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-c52e568c.efs.us-east-1.amazonaws.com:/ashwani /var/opt/gitlab/git-data/repositories
exit 0" > /etc/rc.local

sudo systemctl enable rc-local

#Postgres(RDS),Redis and Google authentication_auth configuration in gitlab.rb file
#RDS
external_url = 'url'
postgresql['enable'] = true
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_host'] = 'gitlab-hu.c1go99wd6ctj.us-east-1.rds.amazonaws.com'
gitlab_rails['db_port'] = '5432'
gitlab_rails['db_username'] = 'db_username'
gitlab_rails['db_password'] = 'db_password'
gitlab_rails['db_database'] = 'db_name' > gitlab.rb

#Redis
gitlab_rails['redis_host'] = "gitlab-hu.cogsb0.0001.use1.cache.amazonaws.com"
gitlab_rails['redis_port'] = 6379 > gitlab.rb

#Google authentication

gitlab_rails['omniauth_allow_single_sign_on'] = true
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['google_oauth2']
gitlab_rails['omniauth_external_providers'] = ['google_oauth2']
gitlab_rails['omniauth_providers'] = [
{
"name" => "google_oauth2",
"app_id" => "233460227025-acj0qpbe9obi012h19897v0p323k9e2v.apps.googleusercontent.com",
"app_secret" => "dEBsPA3mePvL1dmdkIwBD5EZ",
"args" => { "access_type" => "offline", "approval_prompt" => '' }
}
]
gitlab_rails['omniauth_block_auto_created_users'] = true > gitlab.rb


#Reconfiguring gitlab
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart

