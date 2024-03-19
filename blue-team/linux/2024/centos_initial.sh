#!/bin/bash

### PASSWORDS ###

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

# stop firewalld
systemctl stop firewalld.service

### Configure Firewall ###
# install iptables if not already installed
sudo yum install iptables-services
# stop iptables
sudo service iptables stop
# set to default deny
iptables --policy INPUT DROP
iptables --policy OUTPUT DROP
iptables --policy FORWARD DROP
# Allow HTTP and HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
# outbound
sudo iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save and start iptables
service iptables save
service iptables start

# message
echo "running iptables with following ruleset:"
iptables -L

# Update system
yum update -y

# install Tripwire
yum install -y tripwire

# configure Tripwire
tripwire --init

# install ClamAV
yum install -y clamav

# update ClamAV virus definitions
freshclam

# install inotify-tools
yum install -y inotify-tools

echo "Tripwire, ClamAV and Inotify-tools successfully installed"
echo "run tripwire: sudo tripwire --check | less"

yum upgrade -y




