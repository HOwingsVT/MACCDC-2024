#!/bin/bash
# This script is for changing the passwords for linux services: Apache, Bind, Samba, any FTP server, NFS, MySQL, and any websites that are up and running on the server

# Set a variable with a random password
password=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c32; echo)

# Change the Apache password
htpasswd -b /etc/apache2/.htpasswd root $password

# Change the Bind password
rndc-confgen -a -r /dev/urandom -c /etc/bind/rndc.key $password

# Change the Samba password
echo -e "$password\n$password" | smbpasswd -s -a root

# Change the FTP server password
echo -e "$password\n$password" | pure-pw usermod root 

# Change the NFS password
echo "$password" | passwd --stdin root

# Change the MySQL password
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$password';"

# Change the website passwords
for i in $(ls /var/www); do
    htpasswd -b /var/www/$i/.htpasswd root $password
done

echo "Passwords changed successfully!"