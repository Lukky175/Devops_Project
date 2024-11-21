#!/bin/bash

#To make sure user has given correct arguments
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <jenkins_version> <install_method>"
  echo "install_method options: 'war' or 'os'"
  echo "Example: $0 2.485 war"
  exit 1
fi

JENKINS_VERSION="$1"
INSTALL_METHOD="$2"

#Made a Function to install Jenkins via .war file (Windows/Mac/Etc -based)
install_jenkins_war() {
  echo "Downloading Jenkins ${JENKINS_VERSION} WAR file..."
  JENKINS_URL="https://get.jenkins.io/war/${JENKINS_VERSION}/jenkins.war"
  wget -q "${JENKINS_URL}" -O jenkins.war
  if [[ $? -ne 0 ]]; then
    echo "Failed to download Jenkins WAR file. Please check the version."
    exit 1
  fi
  echo "Jenkins WAR file downloaded successfully!"
  echo "To start Jenkins, run: java -jar jenkins.war"
}

#Made a Function to install Jenkins via OS packages (Debian/Ubuntu -based)
install_jenkins_debian() {
  echo "Installing Jenkins ${JENKINS_VERSION} for Debian/Ubuntu..."
  curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/" | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt update -y
  sudo apt install -y openjdk-11-jdk
  sudo apt install -y jenkins="${JENKINS_VERSION}"
}

#Made a Function to install Jenkins via OS packages (Red Hat-based)
install_jenkins_redhat() {
  echo "Installing Jenkins ${JENKINS_VERSION} for Red Hat-based systems..."
  curl -fsSL https://pkg.jenkins.io/redhat/jenkins.io.key | sudo tee \
    /etc/pki/rpm-gpg/RPM-GPG-KEY-jenkins > /dev/null
  sudo yum install -y epel-release
  echo "[jenkins]
name=Jenkins
baseurl=https://pkg.jenkins.io/redhat
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat/jenkins.io.key
enabled=1" | sudo tee /etc/yum.repos.d/jenkins.repo
  sudo yum install -y java-11-openjdk
  sudo yum install -y jenkins-"${JENKINS_VERSION}"
}

#Determining the OS and installing required Jenkins 
install_jenkins_os() {
  if [[ -f /etc/debian_version ]]; then
    install_jenkins_debian
  elif [[ -f /etc/redhat-release ]]; then
    install_jenkins_redhat
  else
    echo "Unsupported OS for package installation. Exiting."
    exit 1
  fi
}

#Main Body of the code
if [[ "${INSTALL_METHOD}" == "war" ]]; then
  install_jenkins_war
elif [[ "${INSTALL_METHOD}" == "os" ]]; then
  install_jenkins_os
else
  echo "Invalid install method: ${INSTALL_METHOD}. Use 'war' or 'os'."
  exit 1
fi

echo "Jenkins ${JENKINS_VERSION} installation completed successfully!"

