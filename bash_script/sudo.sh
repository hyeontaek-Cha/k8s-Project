#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Edit sudoers file to add line after the specified pattern
sed -i '/^root\s*ALL=(ALL)\s*ALL$/a root    ALL=(ALL)       ALL' /etc/sudoers

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Successfully added the line to the sudoers file."
else
    echo "Failed to add the line to the sudoers file."
    exit 1
fi