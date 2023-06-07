#! /bin/bash

yum -y install epel-release 
yum -y update 

# install jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

yum -y upgrade 
yum -y install java-11-openjdk git expect ca-certificates jenkins

# config jenkins port
cat << EOF > /etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="JENKINS_PORT=8880"
EOF

JENKINS_CONFIG_FILE="/etc/sysconfig/jenkins"
NEW_JENKINS_PORT="8880"

sed -i 's/^JENKINS_PORT=.*/JENKINS_PORT="'$NEW_JENKINS_PORT'"/' "$JENKINS_CONFIG_FILE"

# Backup the original jenkins.service file
cp /usr/lib/systemd/system/jenkins.service /usr/lib/systemd/system/jenkins.service.bak

# Replace "JENKINS_PORT=" with "JENKINS_PORT=8880"
 sed -i 's/JENKINS_PORT=/JENKINS_PORT=8880/' /usr/lib/systemd/system/jenkins.service


/usr/bin/expect <<EOF
  set prompt "#"
  set selected_option ""
  spawn bash -c "update-alternatives --config java"
  expect {
    -re {(\d+)\s+java-11} {
      set selected_option \$expect_out(1,string)
      send "\$selected_option\r"
      exp_continue
    }
    "입력하십시오:" {
      if {\$selected_option eq ""} {
        send "\$selected_option\r"
      } 
      exp_continue
    }
    \$prompt
  }
EOF

systemctl daemon-reload

systemctl enable jenkins && systemctl start jenkins

# check jenkins key
cat /var/lib/jenkins/secrets/initialAdminPassword