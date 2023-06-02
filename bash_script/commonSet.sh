#! /bin/bash

# selinux disable
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

# firewalld disable
systemctl stop firewalld && systemctl disable firewalld


# swapoff -a to disable swapping
swapoff -a

# sed to comment the swap partition in /etc/fstab
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# set iptable 
cat <<EOF>> /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF>> /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# set hosts
cat <<EOF>> /etc/hosts
192.168.1.151 master
192.168.1.152 node1
192.168.1.153 node2
192.168.1.154 node3
EOF

# yum install
yum -y install epel-release
yum -y update