#!/bin/bash

# Install and run fail2ban

# Install fail2ban
sudo apt-get install fail2ban

# configure fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

#start fail2ban
sudo systemctl start fail2ban

# Check fail2ban status
sudo systemctl status fail2ban 

# Enable fail2ban
sudo systemctl enable fail2ban