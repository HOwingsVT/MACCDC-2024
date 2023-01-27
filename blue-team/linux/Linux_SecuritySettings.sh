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
#install from tar.gz
tar -xvzf libdaq-3.0.10.tar.gz
cd libdaq-3.0.10
./bootstrap
./configure
make
make install
cd ..
tar xzf gperftools-2.10.tar.gz
cd gperftools-2.10/
./configure
make
make install
cd ..
tar -xvzf snort3-3.1.52.0.tar.gz
cd snort3-3.1.52.0
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make
make install
ldconfig
snort -V
cd ../..
# Configure the NIDS
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.orig
sudo sed -i "s/include \$RULE_PATH/#include \$RULE_PATH/" /etc/snort/snort.conf

# Install and configure a Host Intrusion Detection System (HIDS)
tar -xvzf aide-0.17.4.tar.gz
cd aide-0.17.4
./configure
make
make install
cd ..

# Configure the HIDS
sudo aide --init
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Install and configure Logwatch
tar -xvzf logwatch-7.8.tar.gz
cd logwatch-7.8
./install_logwatch.sh
cd ..

# Configure Logwatch
sudo sed -i "s/MailTo = root/MailTo = you@yourdomain.com/" /etc/logwatch/conf/logwatch.conf

# Install and configure Rootkit Hunter
tar -xvzf rkhunter-1.4.6.tar.gz
cd rkhunter-1.4.6
./installer.sh --layout default --install
cd ..

# Configure Rootkit Hunter
sudo rkhunter --propupd

# Install and configure ClamAV from clamav-1.0.0.linux.x86_64.deb
sudo dpkg -i clamav-1.0.0.linux.x86_64.deb


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
tar -xvzf tripwire-open-source-2.4.3.7.tar.gz
cd tripwire-open-source-2.4.3.7
./configure
make
make install
cd ..



# Configure Tripwire
sudo /usr/sbin/tripwire --init