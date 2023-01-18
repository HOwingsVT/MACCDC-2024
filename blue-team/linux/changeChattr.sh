#!/bin/sh

# Check for root
if [ $(whoami) != "root" ]; then
    echo "Script must be run as root"
    exit 1
fi

#change chattr binary name
dir = $(which chattr)
mv $dir /bin/chat
