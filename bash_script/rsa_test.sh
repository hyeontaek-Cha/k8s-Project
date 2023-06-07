#!/bin/bash

# encrypted_password
encrypted_password="11111111"

# create SSH key
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# host list
hosts=("master" "node1" "node2" "node3")

# copy SSH key
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

!chmod 755 %