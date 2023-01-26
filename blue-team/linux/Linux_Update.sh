#!/bin/bash
# This script is used to automatically run all updates on a Linux system.

# Update apt repositories
echo "Running apt-get update..."
sudo apt-get update

# Install available updates
echo "Running apt-get upgrade..."
sudo apt-get upgrade -y

# Update available packages
echo "Running apt-get dist-upgrade..."
sudo apt-get dist-upgrade -y

# Clean up any packages that are no longer needed
echo "Running apt-get autoremove..."
sudo apt-get autoremove -y

# Clean up package cache
echo "Running apt-get autoclean..."
sudo apt-get autoclean

# Update available security updates
echo "Running unattended-upgrades..."
sudo unattended-upgrade -d

# Display the results of the updates
echo "Update complete."
echo "Please check the output of the commands to verify that all updates were installed successfully."