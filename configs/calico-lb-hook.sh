#!/bin/bash 
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
# docker network inspect kind | jq '.[0].IPAM.Config[0].Subnet' 
#    127.18.0.0/16
# so reserver the range 172.18.255.1-172.18.255.250 for load balancer service
SUBNET=$( docker inspect --type network kind | jq -r '.[0].IPAM.Config[0].Subnet | split(".") | .[0:2] | join(".")')
cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - ${SUBNET}.255.1-${SUBNET}.255.250
EOF


