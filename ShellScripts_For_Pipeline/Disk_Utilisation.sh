#!/bin/bash

# Get the disk usage percentage for the root directory
disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Check if the disk usage is greater than or equal to 80%
if [ "$disk_usage" -ge 80 ]; then
    # Send an email alert if the disk usage exceeds the threshold
    echo "Disk usage is critically high: ${disk_usage}% on $(hostname)" | mail -s "Disk Utilization Alert - ${disk_usage}%" jayapramodmanikantan@gmail.com
fi
