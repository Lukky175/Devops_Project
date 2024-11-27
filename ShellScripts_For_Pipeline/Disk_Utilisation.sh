#!/bin/bash

THRESHOLD=2  # Set the threshold to 80% for disk usage

echo "This Email Is Regards To The Disk Usage and System Health Check"
echo " "
echo " "

# Display full disk usage information (df -h)
echo "Disk usage details for all filesystems:"
df -h

# Get the disk usage percentage for the root (/) directory
USAGE=$(df -h | grep ' /$' | awk '{print $5}' | awk '{print substr($0, 1, length($0)-1)}') # Removes '%'
echo "Current disk usage of root directory: ${USAGE}%"

# Display inode usage for the root filesystem
INODES=$(df -i | grep ' /$' | awk '{print $5}' | awk '{print substr($0, 1, length($0)-1)}')
echo "Current inode usage of root directory: ${INODES}%"

# Show disk read/write statistics
echo "Disk I/O statistics (Read/Write):"
iostat -d -k 1 1 # Shows disk read/write statistics in KB for a single snapshot

# Show system load averages for the past 1, 5, and 15 minutes
echo "System load averages for the past 1, 5, and 15 minutes:"
uptime

# Display memory and swap usage
echo "Memory usage (RAM) and Swap usage:"
free -h

# Get the disk usage percentage for root and check if it's above the threshold
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "Disk usage critical: ${USAGE}% (Threshold: ${THRESHOLD}%)"
    
    # Attempt to send email notification
    email_content="Disk usage critical: ${USAGE}% (Threshold: ${THRESHOLD}%)\n\n$(df -h)\n\n$(iostat -d -k 1 1)\n\n$(uptime)\n\n$(free -h)"
    echo -e "$email_content" | mail -s "Disk Usage and System Health Alert" lakshit175@gmail.com
    
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
