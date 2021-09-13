#!/bin/bash
docker exec -d kind-control-plane /mnt/cni/cni-install.sh
docker exec -d kind-worker /mnt/cni/cni-install.sh
docker exec -d kind-worker2 /mnt/cni/cni-install.sh
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://docs.projectcalico.org/manifests/canal.yaml