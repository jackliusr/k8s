#!/usr/bin/env bash
docker exec -it kind-worker sh -c 'mkdir -p /etc/kubernetes/pki/etcd'
docker cp kind-control-plane:/etc/kubernetes/pki/etcd/ca.key ./configs/etcd/openssl/ca.key
docker cp kind-control-plane:/etc/kubernetes/pki/etcd/ca.crt ./configs/etcd/openssl/ca.crt
docker exec -it kind-worker /mnt/configs/etcd/openssl/gen-key-cert.sh
docker cp kind-control-plane:/etc/kubernetes/manifests/etcd.yaml /tmp/etcd.yaml
sed -i -e 's/172.18.0.2/172.18.0.3/g' /tmp/etcd.yaml
docker cp /tmp/etcd.yaml  kind-worker:/etc/kubernetes/manifests/etcd.yaml