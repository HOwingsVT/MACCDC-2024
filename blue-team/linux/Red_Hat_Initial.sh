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
service sshd restart

# Configure Firewall
# Allow HTTP and HTTPS
firewall-cmd --permanent --zone=public --add-port=80
firewall-cmd --permanent --zone=public --add-port=8161
vnc_port=$(netstat -tulnp | awk '/vnc/ {print $4}' | sed 's/[^:]*://')
firewall-cmd --permanent --zone=public --add-port=$vnc_port
firewall-cmd --permanent --zone=public --add-port=22


# get list of all current open ports
ports=$(netstat -tulnp | awk '/^tcp/ {print $4}' | sed 's/[^:]*://')

# get VNC port (if it exists)
vnc_port=$(netstat -tulnp | awk '/vnc/ {print $4}' | sed 's/[^:]*://')

# loop through all open ports
for port in $ports
do
	# if port is not 22, 80, 8161, or VNC, close it
	if [ "$port" != "22" ] && [ "$port" != "80" ] && [ "$port" != "8161" ] && [ "$port" != "$vnc_port" ]
	then
		firewall-cmd --zone=public --remove-port=$port/tcp --permanent
		echo "Port $port closed."
	fi
done

# reload firewall for changes to take effect
firewall-cmd --reload


# Save iptables
service iptables save


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

yum upgrade -y