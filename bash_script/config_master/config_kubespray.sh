#! /bin/bash
# -*- coding: utf-8 -*-

# Add the jenkins line using sed
# sed -i '/^root\s*ALL=(ALL)\s*ALL/a jenkins\tALL=(ALL) NOPASSWD: ALL' /etc/sudoers

# install packages
yum -y install ansible python3 

cd /var/lib/jenkins

# git clone
git clone --single-branch --branch v2.19.1 https://github.com/kubernetes-sigs/kubespray.git


# config requirements.txt
cd ./kubespray

cat << EOF > ~/kubespray/requirements.txt
ansible==5.7.1
ansible-core==2.12.5
cryptography==3.4.8
jinja2==2.11.3
netaddr==0.7.19
pbr==5.4.4
jmespath==0.9.5
ruamel.yaml==0.16.10
ruamel.yaml.clib==0.2.6
MarkupSafe==1.1.1
EOF

# pip install error
pip3 install --upgrade --ignore-installed pip setuptools

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

# start ansible-playbook
cd /var/lib/jenkins/kubespray

# ping check
ansible all -i inventory/first_cluster/inventory.ini -m ping

ansible-playbook  -i ./inventory/first_cluster/inventory.ini cluster.yml


# config alias autocomplete
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc 
echo 'complete -F __start_kubectl k' >>~/.bashrc