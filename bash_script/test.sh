#! /bin/bash

yum -y install maven git


wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y install jenkins


systemctl start jenkins && systemctl enable jenkins


wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

yum install -y ca-certificates

yum install -y java-11-openjdk jenkins
yum install jenkins