#!/bin/bash
# Script to change the passwords of all users

# Get all users
USERS=$(cut -d: -f1 /etc/passwd)

PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Loop through all users
for USER in $USERS
  
  # Generate random password
  
  # Change user password
  echo "$USER:$PASS" | chpasswd
  
  # Display new password
  echo "Password for user $USER changed to $PASS"
done


