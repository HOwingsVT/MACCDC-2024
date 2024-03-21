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
# stop nftables
sudo systemctl stop nftables
sudo systemctl disable nftables
# sudo ufw disable
# flush previous chains/rules
iptables -X
iptables -F
# set to default deny
iptables --policy INPUT DROP
iptables --policy OUTPUT DROP
iptables --policy FORWARD DROP
# Allow DNS and NTP
sudo iptables -A INPUT -p tcp -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 123 -j ACCEPT
# outbound
sudo iptables -A OUTPUT -p tcp -p udp --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 123 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save and start iptables
sudo iptables-save > /etc/iptables/rules.v4
sudo systemctl enable iptables
sudo systemctl restart iptables

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

echo "Tripwire, ClamAV successfully installed"
echo "run tripwire: sudo tripwire --check | less"
# message
echo "running firewall with following ruleset:"
iptables -L
echo "firewall status:"
sudo systemctl status iptables

# install updates on bind
# sudo apt install bind9

### changing bind(dns service) password
# rndc-confgen -a -r /dev/urandom -c /etc/bind/rndc.key $password

## restart
# sudo systemctl restart bind9

## to view services
# systemctl list-units --type=service | grep bind
