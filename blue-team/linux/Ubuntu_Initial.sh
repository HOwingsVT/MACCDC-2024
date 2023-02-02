#!/bin/bash

# Change root password
echo 'Please enter a new password for root user'
read -s root_password
echo
echo 'Root password successfully changed!'
echo $root_password | passwd --stdin root

# Change password for every user
for user in $(ls /home)
do
    echo "Please enter a new password for user $user"
    read -s new_password
    echo
    echo $new_password | passwd --stdin $user
    echo "Password for user $user successfully changed!"
done

# Enable SSH key-only access
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
service ssh restart

# Configure Firewall
# Allow HTTP and HTTPS
ufw allow http
# Allow SSH
ufw allow vnc
# Reload firewall
ufw reload

# Update system
apt update -y

# install Tripwire
apt install -y tripwire

# configure Tripwire
tripwire --init

# install ClamAV
apt install -y clamav

# update ClamAV virus definitions
freshclam

# install inotify-tools
apt install -y inotify-tools

echo "Tripwire, ClamAV and Inotify-tools successfully installed"


apt upgrade -y