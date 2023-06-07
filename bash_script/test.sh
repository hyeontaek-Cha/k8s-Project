#! /bin/bash

update-alternatives --config java

/usr/bin/expect <<EOF
  set prompt "#"
  spawn bash -c update-alternatives --config java
  expect {
    "Selection*" { send "3\r"; exp_continue }
    $prompt
}
EOF