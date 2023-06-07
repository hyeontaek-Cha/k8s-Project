#! /bin/bash

cd ~/

git clone https://github.com/hyeontaek-Cha/k8s-Project.git

cd ~/k8s-Project/bash_script/

chmod 755 bash_script/*

# encrypted_password
encrypted_password="11111111"

# create SSH key
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# host list
hosts=("master" "node1" "node2" "node3")

# copy hosts SSH key
for host in "${hosts[@]}"; do

  /usr/bin/expect <<EOF
  set prompt "#"
  spawn bash -c "ssh-copy-id root@$host"
  expect {
    "yes/no" { send "yes\r"; exp_continue }
    "password" { send "$encrypted_password\r"; exp_continue }
    $prompt
  }
EOF

done

# config ngrok
tar xvzf ~/k8s-Project/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin

# Add authtoken
ngrok config add-authtoken 2QrDBdwRQLKbfch4rIyGBW0kmnr_6m2g115WDJg96jfTLcemK

# Start a tunnel
ngrok http 8880