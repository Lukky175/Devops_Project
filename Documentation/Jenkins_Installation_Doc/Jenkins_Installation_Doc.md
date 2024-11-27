Jenkins Installation Script Documentation
This documentation explains the functionality and usage of the Jenkins installation shell script. The script automates the process of installing Jenkins, along with its prerequisites, for multiple operating systems. It supports version-specific installations and includes robust error handling to manage various scenarios.

Features
Version-specific Installation: Installs the specified version of Jenkins.
Cross-Platform Support: Supports major operating systems:
Ubuntu/Debian
CentOS/RHEL
macOS
Windows
Java Installation: Installs OpenJDK 17 as a prerequisite for Jenkins.
Error Handling:
Prevents null input for required arguments.
Displays meaningful error messages for unsupported OS types or installation failures.
Service Verification: Checks the status of Jenkins after installation.
Usage
The script requires two arguments: the Jenkins version and the operating system type.

Command Syntax
bash
Copy code
./install_jenkins.sh <Jenkins_Version> <OS_Type>
Arguments
<Jenkins_Version>: Specifies the Jenkins version to install (e.g., 2.361.1).
<OS_Type>: Specifies the operating system. Supported values:
ubuntu
debian
centos
rhel
macos
windows
Script Functionality
1. Argument Validation
Ensures both arguments (<Jenkins_Version> and <OS_Type>) are provided.
Displays an error message and exits if any argument is missing:
Example:
bash
Copy code
Error: Please provide the Jenkins version as an argument (e.g., 2.361.1).
2. Java Installation
Installs OpenJDK 17 as a prerequisite based on the operating system:

Ubuntu/Debian: Installs Java using the apt package manager.
CentOS/RHEL: Installs Java using the yum package manager.
macOS: Installs Java using Homebrew.
Windows: Provides instructions for manual installation from Oracle's website.
3. Jenkins Installation
Installs Jenkins using OS-specific commands:

Ubuntu/Debian:
Adds Jenkins GPG key and repository.
Installs Jenkins via apt and starts the service.
CentOS/RHEL:
Adds Jenkins repository and GPG key.
Installs Jenkins via yum, enables, and starts the service.
macOS:
Installs Jenkins using Homebrew.
Provides instructions to start the service manually.
Windows:
Downloads the Jenkins MSI file for manual installation.
4. Service Verification
Checks the Jenkins service status based on the operating system:

Linux-based systems (Ubuntu/Debian/CentOS/RHEL):
Uses systemctl to display Jenkins service status.
macOS:
Provides the command to list services managed by Homebrew.
Windows:
Advises users to verify Jenkins installation via the Windows Services Manager.
5. Post-Installation Instructions
For Linux-based systems:
Access Jenkins at http://<your-server-ip>:8080.
Retrieve the initial admin password from:
bash
Copy code
/var/lib/jenkins/secrets/initialAdminPassword
For macOS:
Start Jenkins using:
bash
Copy code
brew services start jenkins-lts
For Windows:
Run the downloaded jenkins.msi to complete the installation.
Error Handling
The script handles the following errors:

Missing Arguments:
Displays an error message and exits if either <Jenkins_Version> or <OS_Type> is missing.
Unsupported OS:
Displays an error for unsupported OS types.
Installation Failures:
Catches errors during the installation of Java or Jenkins and exits with descriptive messages.
Sample Commands
Ubuntu/Debian:
bash
Copy code
./install_jenkins.sh 2.361.1 ubuntu
CentOS/RHEL:
bash
Copy code
./install_jenkins.sh 2.361.1 centos
macOS:
bash
Copy code
./install_jenkins.sh 2.361.1 macos
Windows:
bash
Copy code
./install_jenkins.sh 2.361.1 windows
