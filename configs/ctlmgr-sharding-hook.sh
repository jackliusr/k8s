#!/usr/bin/env bash
sleep 3m
docker cp ./configs/controller-mgr/kube-controller-manager-1.yaml kind-control-plane:/etc/kubernetes/manifests/kube-controller-manager-1.yaml
docker exec kind-control-plane rm /etc/kubernetes/manifests/kube-controller-manager.yaml

docker cp ./configs/controller-mgr/kube-controller-manager-2.yaml kind-control-plane2:/etc/kubernetes/manifests/kube-controller-manager-2.yaml
docker exec kind-control-plane2 rm /etc/kubernetes/manifests/kube-controller-manager.yaml

docker cp ./configs/controller-mgr/kube-controller-manager-3.yaml kind-control-plane3:/etc/kubernetes/manifests/kube-controller-manager-3.yaml
docker exec kind-control-plane3 rm /etc/kubernetes/manifests/kube-controller-manager.yaml

kubectl apply -f ./configs/controller-mgr/lease2.yaml
kubectl apply -f ./configs/controller-mgr/lease3.yaml
kubectl apply -f ./configs/controller-mgr/system\:\:leader-locking-kube-controller-manager.yaml
kubectl apply -f ./configs/controller-mgr/cluster-role-kube-controller-manager.yaml