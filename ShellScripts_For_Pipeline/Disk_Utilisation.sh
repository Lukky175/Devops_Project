#!/bin/bash

THRESHOLD=2
#As per the question this should be 80% but for now for testing purposes i have done this on 2% in order to recieve email
echo "This Email Is Regards To The DiskUsage"
echo " "
echo " "
# Use grep to filter the '/' line and awk to extract the usage percentage
USAGE=$(df -h | grep ' /$' | awk '{print $5}' | awk '{print substr($0, 1, length($0)-1)}') # Removes '%'

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "Disk usage critical: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    exit 1 # Non-zero exit code for critical disk usage
else
    echo "Disk usage is under control: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    exit 0 # Zero exit code for normal usage
fi
