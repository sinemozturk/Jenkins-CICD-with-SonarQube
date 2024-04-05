#!/bin/bash

# Update package index
sudo apt update

# Install Java JDK 11
sudo apt-get install -y openjdk-11-jdk

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get install -y jenkins

# Configure Jenkins to use port 8082
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8082/' /etc/default/jenkins
sudo sed -i 's/Environment="JENKINS_PORT=8080"/Environment="JENKINS_PORT=8082"/' /lib/systemd/system/jenkins.service

sudo systemctl daemon-reload
sudo systemctl restart jenkins.service

# Install Maven
sudo apt-get install -y maven
