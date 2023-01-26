#!/bin/bash

# Install Firewall
sudo apt-get install -y ufw

# Configure Firewall
sudo ufw enable

# Deny all incoming connections
sudo ufw default deny incoming

# Allow all outgoing connections
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow ssh

# Restrict SSH Access
sudo ufw limit ssh

# Allow web services
sudo ufw allow http
sudo ufw allow https

# Install and configure a Network Intrusion Detection System (NIDS)
sudo apt-get install -y snort

# Configure the NIDS
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.orig
sudo sed -i "s/include \$RULE_PATH/#include \$RULE_PATH/" /etc/snort/snort.conf

# Install and configure a Host Intrusion Detection System (HIDS)
sudo apt-get install -y aide

# Configure the HIDS
sudo aide --init
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Install and configure Logwatch
sudo apt-get install -y logwatch

# Configure Logwatch
sudo sed -i "s/MailTo = root/MailTo = you@yourdomain.com/" /etc/logwatch/conf/logwatch.conf

# Install and configure Rootkit Hunter
sudo apt-get install -y rkhunter

# Configure Rootkit Hunter
sudo rkhunter --propupd

# Install and configure ClamAV
sudo apt-get install -y clamav

# Configure ClamAV
sudo freshclam

# Install and configure DenyHosts
sudo apt-get install -y denyhosts

# Configure DenyHosts
sudo sed -i "s/^DENY_THRESHOLD_INVALID = .*/DENY_THRESHOLD_INVALID = 5/" /etc/denyhosts.conf

# Install and configure OSSEC
sudo apt-get install -y ossec-hids

# Configure OSSEC
sudo sed -i "s/<email_notification>no<\/email_notification>/<email_notification>yes<\/email_notification>/" /var/ossec/etc/ossec.conf
sudo sed -i "s/<email_to>your@address.com<\/email_to>/<email_to>you@yourdomain.com<\/email_to>/" /var/ossec/etc/ossec.conf

# Install and configure Tripwire
sudo apt-get install -y tripwire

# Configure Tripwire
sudo /usr/sbin/tripwire --init