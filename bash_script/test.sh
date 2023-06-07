#! /bin/bash

update-alternatives --config java

/usr/bin/expect <<EOF
  set prompt "#"
  expect {
    "Selection*" { send "3\r"; exp_continue }
    $prompt
}
EOF