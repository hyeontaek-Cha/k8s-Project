# auto ssh_keygen rsa
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

/usr/bin/expect <<EOE
set prompt "#"
spawn bash -c "ssh-copy-id root@master"
expect {
  "yes/no" { send "yes\r"; exp_continue }
  "password" { send "11111111\r"; exp_continue }
  $prompt
}

spawn bash -c "ssh-copy-id root@node1"
expect {
  "yes/no" { send "yes\r"; exp_continue }
  "password" { send "11111111\r"; exp_continue }
  $prompt
}

spawn bash -c "ssh-copy-id root@node2"
expect {
  "yes/no" { send "yes\r"; exp_continue }
  "password" { send "11111111\r"; exp_continue }
  $prompt
}

spawn bash -c "ssh-copy-id root@node3"
expect {
  "yes/no" { send "yes\r"; exp_continue }
  "password" { send "11111111\r"; exp_continue }
  $prompt
}
EOE