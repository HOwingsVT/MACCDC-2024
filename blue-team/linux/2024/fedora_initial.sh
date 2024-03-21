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
# sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
# systemctl restart sshd

# Configure Firewall
sudo firewall-cmd --set-default-zone=drop
# Allow HTTP and HTTPS
firewall-cmd --permanent --zone=public --add-port=110/tcp  # POP
firewall-cmd --permanent --zone=public --add-port=143/tcp  # IMAP
firewall-cmd --permanent --zone=public --add-port=25/tcp   # SMTP
# firewall-cmd --permanent --zone=public --add-port=80/tcp  # HTTP (may need not sure what "webapps means")
# Reload firewall
firewall-cmd --reload

# Update system
dnf update -y


# install Tripwire
dnf install -y tripwire

# configure Tripwire
tripwire --init

# install ClamAV
dnf install -y clamav

# update ClamAV virus definitions
freshclam

# install inotify-tools
dnf install -y inotify-tools

echo "Tripwire, ClamAV and Inotify-tools successfully installed"

dnf upgrade -y
