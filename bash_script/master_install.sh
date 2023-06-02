#! /bin/bash

# install packages
yum -y install ansible python3 git expect
yum -y update


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

# git clone
git clone https://github.com/kubernetes-sigs/kubespray.git


# set and install requirements.txt
cd ~/kubespray

cat << EOF > ~/kubespray/requirements.txt
ansible==4.10.0
ansible-core==2.11.10
cryptography==3.4.8
jinja2==3.0.0
jmespath==0.10.0
MarkupSafe==2.0.1
netaddr==0.8.0
pbr==5.11.1
ruamel.yaml==0.17.21
ruamel.yaml.clib==0.2.7
EOF
# pip install error
sudo -H pip3 install --upgrade --ignore-installed pip setuptools

pip3 install -r requirements.txt

# set  inventory.ini
cp -rfp inventory/sample inventory/first_cluster

cd inventory/first_cluster

cat << EOF > inventory.ini
[all]
master ansible_host=192.168.1.151  # ip=192.168.1.151 etcd_member_name=etcd1
node1 ansible_host=192.168.1.152   # ip=192.168.1.152
node2 ansible_host=192.168.1.153   # ip=192.168.1.153
node3 ansible_host=192.168.1.154   # ip=192.168.1.154

[kube_control_plane]
master

[etcd]
master

[kube_node]
node1
node2
node3

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
EOF

#start ansible
cd ~/kubespray
ansible-playbook  -i ./inventory/first_cluster/inventory.ini cluster.yml

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc 
echo 'complete -F __start_kubectl k' >>~/.bashrc