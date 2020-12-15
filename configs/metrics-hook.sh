#!/bin/bash
# https://github.com/kontena/kubelet-rubber-stamp/tree/master/deploy
# ./configs/deploy are from above repository
kubectl apply -f ./configs/deploy
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
