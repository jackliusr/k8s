#!/bin/sh  
kubectl apply -f https://docs.projectcalico.org/v3.19/manifests/calico.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
