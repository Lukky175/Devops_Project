#Prints Top 15 Processes by memory usage
#!/bin/bash
echo "Current running processes:"
ps aux --sort=-%mem | head -n 15
