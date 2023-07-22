#!/usr/bin/env bash
docker exec -it kind-worker sh -c 'mkdir -p /etc/kubernetes/pki/etcd'
docker cp kind-control-plane:/etc/kubernetes/pki/etcd/ca.key /tmp/ca.key
docker cp kind-control-plane:/etc/kubernetes/pki/etcd/ca.crt /tmp/ca.crt
docker cp /tmp/ca.key kind-worker:/etc/kubernetes/pki/etcd/ca.key
docker cp /tmp/ca.crt kind-worker:/etc/kubernetes/pki/etcd/ca.crt
docker exec -it kind-worker /mnt/configs/common/gen-etcd-certs.sh