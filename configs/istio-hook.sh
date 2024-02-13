#!/bin/bash 
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system \
                --for=condition=ready pod \
                --selector=app=metallb \
                --timeout=90s

# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
# docker network inspect kind | jq '.[0].IPAM.Config[0].Subnet' 
#    127.18.0.0/16
# so reserver the range 172.18.255.1-172.18.255.250 for load balancer service
SUBNET=$( docker inspect --type network kind | jq -r '.[0].IPAM.Config[0].Subnet | split(".") | .[0:2] | join(".")')
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
   - ${SUBNET}.255.1-${SUBNET}.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF
sleep 5

istioctl install --set profile=demo -y


