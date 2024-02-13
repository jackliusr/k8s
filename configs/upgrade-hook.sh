#!/bin/sh  
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
docker exec -d kind-control-plane /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-control-plane2 /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-control-plane3 /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-worker /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-worker2 /mnt/configs/upgrade/kubeadm-install.sh
