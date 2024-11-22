#!/bin/bash

THRESHOLD=80
EMAIL="lakshit175@gmail.com"

//Check disk utilization
DISK_USAGE=$(df -h / | grep '/' | awk '{print $5}' | sed 's/%//')

//If condition
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "Disk usage is above ${THRESHOLD}%: Current usage is ${DISK_USAGE}%" | mail -s "Disk Utilization Alert" "$EMAIL"
else
    echo "Disk utilization is under control: ${DISK_USAGE}%"
fi
