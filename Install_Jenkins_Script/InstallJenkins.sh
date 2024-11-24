#1 refers to stdout (standard output).
#2 refers to stderr (standard error).
#1>&2 means "redirect stdout to stderr."

#!/bin/bash

#To Prevent Null Input
if [ -z "$1" ]; then
    echo "Error: Please provide the Jenkins version as an argument (e.g., 2.361.1)." 1>&2
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: Please provide the OS type (e.g., ubuntu, centos, macos, windows)." 1>&2
    exit 1
fi

JENKINS_VERSION=$1
OS_TYPE=$2

#Installing Compatible Java (OpenJDK 17) based on OS
echo "Installing Java..."
if [ "$OS_TYPE" == "ubuntu" ] || [ "$OS_TYPE" == "debian" ]; then
    sudo apt update && sudo apt install -y openjdk-17-jdk || { echo "Error: Failed to install Java on Ubuntu/Debian." 1>&2; exit 1; }
elif [ "$OS_TYPE" == "centos" ] || [ "$OS_TYPE" == "rhel" ]; then
    sudo yum install -y java-17-openjdk-devel || { echo "Error: Failed to install Java on CentOS/RHEL." 1>&2; exit 1; }
elif [ "$OS_TYPE" == "macos" ]; then
    brew install openjdk@17 || { echo "Error: Failed to install Java on macOS. Please ensure Homebrew is installed." 1>&2; exit 1; }
elif [ "$OS_TYPE" == "windows" ]; then
    echo "Please manually install Java for Windows from https://www.oracle.com/java/technologies/javase-jdk17-downloads.html"
else
    echo "Error: Unsupported OS type. Please provide either 'ubuntu', 'centos', 'macos', or 'windows'." 1>&2
    exit 1
fi

#Install Jenkins based on OS (Ubuntu/Debian/Centos/Rhel/Macos/Windows/etc(war file))
echo "Installing Jenkins version $JENKINS_VERSION..."
if [ "$OS_TYPE" == "ubuntu" ] || [ "$OS_TYPE" == "debian" ]; then
    sudo apt update && sudo apt install -y curl gnupg || { echo "Error: Failed to install dependencies on Ubuntu/Debian." 1>&2; exit 1; }
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null || { echo "Error: Failed to add Jenkins key." 1>&2; exit 1; }
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update && sudo apt install -y jenkins || { echo "Error: Failed to install Jenkins on Ubuntu/Debian." 1>&2; exit 1; }
    sudo systemctl enable jenkins && sudo systemctl start jenkins
elif [ "$OS_TYPE" == "centos" ] || [ "$OS_TYPE" == "rhel" ]; then
    sudo yum install -y wget || { echo "Error: Failed to install wget on CentOS/RHEL." 1>&2; exit 1; }
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo || { echo "Error: Failed to add Jenkins repository." 1>&2; exit 1; }
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key || { echo "Error: Failed to add Jenkins key." 1>&2; exit 1; }
    sudo yum install -y jenkins || { echo "Error: Failed to install Jenkins on CentOS/RHEL." 1>&2; exit 1; }
    sudo systemctl enable jenkins && sudo systemctl start jenkins
elif [ "$OS_TYPE" == "macos" ]; then
    brew install jenkins-lts || { echo "Error: Failed to install Jenkins on macOS." 1>&2; exit 1; }
    echo "To start Jenkins, use: 'brew services start jenkins-lts'"
elif [ "$OS_TYPE" == "windows" ]; then
    echo "Downloading Jenkins for Windows..."
    curl -O https://get.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.msi || { echo "Error: Failed to download Jenkins MSI file." 1>&2; exit 1; }
    echo "Please run the downloaded 'jenkins.msi' to complete the installation."
else
    echo "Error: Unsupported OS type. Please provide either 'ubuntu', 'centos', 'macos', or 'windows'." 1>&2
    exit 1
fi

#Displaying the status of Jenkins after Installation
echo "Checking Jenkins status..."
if [ "$OS_TYPE" == "ubuntu" ] || [ "$OS_TYPE" == "debian" ] || [ "$OS_TYPE" == "centos" ] || [ "$OS_TYPE" == "rhel" ]; then
    sudo systemctl status jenkins --no-pager
elif [ "$OS_TYPE" == "macos" ]; then
    echo "To check Jenkins status, use: 'brew services list'"
else
    echo "For Windows, verify Jenkins installation via the Windows Services Manager."
fi

#Final message if Jenkins is Installed
if [ "$OS_TYPE" == "ubuntu" ] || [ "$OS_TYPE" == "debian" ] || [ "$OS_TYPE" == "centos" ] || [ "$OS_TYPE" == "rhel" ]; then
    echo "Jenkins installation completed successfully."
    echo "Visit http://<your-server-ip>:8080 to access Jenkins."
elif [ "$OS_TYPE" == "macos" ]; then
    echo "Jenkins installed on macOS. Start it with 'brew services start jenkins-lts'."
elif [ "$OS_TYPE" == "windows" ]; then
    echo "Run 'jenkins.msi' to complete the installation on Windows."
fi
