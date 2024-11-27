#!/bin/bash

THRESHOLD=2  # Set the threshold to 80% for disk usage

echo "This Email Is Regards To The Disk Usage"
echo " "
echo " "

# Display full disk usage information (df -h)
echo "Current disk usage details:"
df -h

# Get the disk usage percentage for the root (/) directory
USAGE=$(df -h | grep ' /$' | awk '{print $5}' | awk '{print substr($0, 1, length($0)-1)}') # Removes '%'

echo "Current disk usage of root directory: ${USAGE}%"

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "Disk usage critical: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    # Attempt to send email
    echo "Disk usage critical: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    
    if [ $? -eq 0 ]; then
        echo "Email sent successfully."
    else
        echo "Failed to send email."
    fi
    exit 1 # Non-zero exit code for critical disk usage
else
    echo "Disk usage is under control: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    exit 0 # Zero exit code for normal usage
fi
