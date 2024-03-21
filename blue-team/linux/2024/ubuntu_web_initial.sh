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

### Configure Firewall ###
# stop iptables
sudo ufw disable
# flush previous chains/rules
iptables -X
iptables -F
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
sudo iptables-save > /etc/iptables/rules.v4
sudo ufw enable

# Update system
apt-get update

# install Tripwire
apt-get install tripwire

# configure Tripwire
tripwire --init

# install ClamAV
apt-get install clamav

# update ClamAV virus definitions
freshclam

apt-get upgrade -y

echo "Tripwire, ClamAV and Inotify-tools successfully installed"
echo "run tripwire: sudo tripwire --check | less"
# message
echo "running firewall with following ruleset:"
iptables -L

### APACHE STUFF - DO MANUALLY ###

## Change the Apache password
# htpasswd -b /etc/apache2/.htpasswd root $password

# # Check apache/httpd status: 
# sudo systemctl status apache2 
# sudo systemctl status httpd

# # Restart apache/httpd: 
# sudo systemctl restart apache2 
# sudo systemctl restart httpd

