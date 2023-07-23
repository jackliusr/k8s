#!/usr/bin/env bash
docker exec -it kind-worker sh -c 'mkdir -p /etc/kubernetes/pki/etcd'
docker cp kind-control-plane:/etc/kubernetes/pki/etcd/ca.key ./configs/etcd/openssl/ca.key
docker cp kind-control-plane:/etc/kubernetes/pki/etcd/ca.crt ./configs/etcd/openssl/ca.crt
# valid option: openssl,cfssl
docker exec -it kind-worker /mnt/configs/etcd/cfssl/gen-key-cert.sh 
docker cp kind-control-plane:/etc/kubernetes/manifests/etcd.yaml /tmp/etcd.yaml

export CTL_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-control-plane)
export WORKER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-worker)
sh -c "sed -i -e 's/${CTL_IP}/${WORKER_IP}/g' /tmp/etcd.yaml"
docker cp /tmp/etcd.yaml  kind-worker:/etc/kubernetes/manifests/etcd.yaml
sh -c "docker exec -it  kind-control-plane sed -i '/127.0.0.1:2379/a \ \ \ \ - --etcd-servers-overrides=\/events#https:\/\/${WORKER_IP}:2379' /etc/kubernetes/manifests/kube-apiserver.yaml"
#check changes
docker exec -it kind-control-plane grep etcd-servers  /etc/kubernetes/manifests/kube-apiserver.yaml