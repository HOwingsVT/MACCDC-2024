#!/bin/bash

# Generates an ssh key
ssh-keygen

# Logs in via ssh
ssh user@host

# Changes the passwords for all users
passwd -s 

# Enable key authentication by ssh for only our key
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config

# Enable only authentication through keys for ssh and users
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# Restart sshd
service sshd restart