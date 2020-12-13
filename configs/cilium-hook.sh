#!/bin/bash
docker exec -d kind-control-plane /mnt/cni/cni-install.sh
docker exec -d kind-worker/mnt/cni/cni-install.sh
docker exec -d kind-worker2 /mnt/cni/cni-install.sh

helm repo add cilium https://helm.cilium.io/
docker pull cilium/cilium:v1.9.1
kind load docker-image cilium/cilium:v1.9.1
helm install cilium cilium/cilium --version 1.9.1 \
   --namespace kube-system \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set bpf.masquerade=false \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
