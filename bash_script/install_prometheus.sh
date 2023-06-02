#! /bin/bash

# install metric server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.3/components.yaml

# Get the current deployment YAML
CURRENT_YAML=$(kubectl get deployment.apps/metrics-server -n kube-system -o yaml)

# Add the '--kubelet-insecure-tls' option to the command line arguments
NEW_YAML=$(echo "$CURRENT_YAML" | sed 's/args:$/args:\n        - --kubelet-insecure-tls/g')

echo "$NEW_YAML" | kubectl apply -f -

# waiting pod loading
sleep 1m

# create namespace
kubectl create namespace monitoring

cd ~

#install prometheus
git clone https://github.com/hali-linux/my-prometheus-grafana.git

cd my-prometheus-grafana

kubectl apply -f prometheus-cluster-role.yaml
sleep 3s

kubectl apply -f prometheus-config-map.yaml
sleep 3s

kubectl apply -f prometheus-deployment.yaml
sleep 3s

kubectl apply -f prometheus-node-exporter.yaml
sleep 3s

kubectl apply -f prometheus-svc.yaml
sleep 3s


#install kube-state
kubectl apply -f kube-state-cluster-role.yaml
sleep 3s

kubectl apply -f kube-state-deployment.yaml
sleep 3s

kubectl apply -f kube-state-svcaccount.yaml
sleep 3s

kubectl apply -f kube-state-svc.yaml
sleep 3s


cd ~/my-prometheus-grafana/

# install grafana
kubectl apply -f grafana.yaml