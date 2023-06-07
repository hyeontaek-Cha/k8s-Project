#! /bin/bash

# install metric server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.3/components.yaml

CURRENT_YAML=$(kubectl get deployment.apps/metrics-server -n kube-system -o yaml)

NEW_YAML=$(echo "$CURRENT_YAML" | sed '/- --secure-port=4443/a\        - --kubelet-insecure-tls')

NEW_YAML=$(echo "$NEW_YAML" | sed '/dnsPolicy: ClusterFirst/a\        hostNetwork: true')

echo "$NEW_YAML" | kubectl apply -f -

sleep 5s

pod_name=$(kubectl get pod -n kube-system -l app=metrics-server -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod -n kube-system $pod_name --grace-period=0 --force

pod_name=$(kubectl get pod -n kube-system -l app=kube-state-metrics -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod -n kube-system $pod_name --grace-period=0 --force

# waiting pod loading
sleep 20s

# create namespace
kubectl create namespace monitoring

cd ~

#install prometheus
git clone https://github.com/hali-linux/my-prometheus-grafana.git

cd my-prometheus-grafana


# replace prometheus-cluster-role.yaml
tmp_file=$(mktemp)

sed "s/$search_string/$replace_string/g" "$file_path" > "$tmp_file"

mv "$tmp_file" "$file_path"

rm "$tmp_file"

#install prometheus
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