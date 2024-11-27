#!/bin/bash

THRESHOLD=80  # Set the threshold to 80% for disk usage

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
    # You can add the mail sending functionality here if needed.
    exit 1 # Non-zero exit code for critical disk usage
else
    echo "Disk usage is under control: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    exit 0 # Zero exit code for normal usage
fi
