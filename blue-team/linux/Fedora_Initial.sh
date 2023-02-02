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
systemctl restart sshd

# Configure Firewall
# Allow HTTP and HTTPS
firewall-cmd --permanent --zone=public --add-port=9000
firewall-cmd --permanent --zone=public --add-port=9200
vnc_port=$(netstat -tulnp | awk '/vnc/ {print $4}' | sed 's/[^:]*://')
firewall-cmd --permanent --zone=public --add-port=$vnc_port
firewall-cmd --permanent --zone=public --add-port=22
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