#!/bin/bash

#Lakshit Tyagi - E23CSEU1497
#This Script automates the backup of files and directories.
#How To Use This Shell Script: ./backup.sh <backup_from> <backup_to> [--compress]

#Input variables
SOURCE_DIR="$1"
DEST_DIR="$2"
COMPRESS_FLAG="$3"

#File To Store Logs
LOG_FILE="backup.log"

#Initialize the log file if it doesn't exist
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi

#Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

#Check if source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    log_message "ERROR: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

#Check if the destination directory exists or create it
if [[ ! -d "$DEST_DIR" ]]; then
    echo "Destination directory $DEST_DIR does not exist. Creating it..."
    mkdir -p "$DEST_DIR"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to create destination directory $DEST_DIR."
        log_message "ERROR: Failed to create destination directory $DEST_DIR."
        exit 1
    fi
    log_message "INFO: Created destination directory $DEST_DIR."
fi

#Backup
BACKUP_NAME="backup_$(basename "$SOURCE_DIR")_$(date '+%Y%m%d_%H%M%S')"
if [[ "$COMPRESS_FLAG" == "--compress" ]]; then
    BACKUP_FILE="$DEST_DIR/$BACKUP_NAME.tar.gz"
    echo "Creating compressed backup at $BACKUP_FILE..."
    tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .
    if [[ $? -eq 0 ]]; then
        echo "Backup successful: $BACKUP_FILE"
        log_message "SUCCESS: Compressed backup created at $BACKUP_FILE."
    else
        echo "Error: Failed to create compressed backup."
        log_message "ERROR: Failed to create compressed backup."
        exit 1
    fi
else
    BACKUP_DIR="$DEST_DIR/$BACKUP_NAME"
    echo "Copying files to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    cp -a "$SOURCE_DIR/"* "$BACKUP_DIR/"
    if [[ $? -eq 0 ]]; then
        echo "Backup successful: $BACKUP_DIR"
        log_message "SUCCESS: Files copied to $BACKUP_DIR."
    else
        echo "Error: Failed to copy files."
        log_message "ERROR: Failed to copy files."
        exit 1
    fi
fi

#Cleanup: Remove backups older than 7 days
echo "Cleaning up backups older than 7 days in $DEST_DIR..."
find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \; >> "$LOG_FILE" 2>&1
find "$DEST_DIR" -type d -name "backup_*" -mtime +7 -exec rm -rf {} \; >> "$LOG_FILE" 2>&1

if [[ $? -eq 0 ]]; then
    echo "Cleanup successful."
    log_message "INFO: Cleanup successful. Old backups removed."
else
    echo "Error during cleanup."
    log_message "ERROR: Failed to remove old backups."
fi

echo "Backup process completed."
log_message "INFO: Backup process completed successfully."
