#!/bin/sh  
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
docker exec -d kind-control-plane /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-control-plane2 /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-control-plane3 /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-worker /mnt/configs/upgrade/kubeadm-install.sh
docker exec -d kind-worker2 /mnt/configs/upgrade/kubeadm-install.sh
