#!/usr/bin/env bash
cd "$(dirname "$0")"
pwd
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config server.conf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out server.crt -days 10000 \
    -extensions v3_ext -extfile server.conf -sha256

openssl genrsa -out peer.key 2048
openssl req -new -key peer.key -out peer.csr -config server.conf
openssl x509 -req -in peer.csr -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out peer.crt -days 10000 \
    -extensions v3_ext -extfile server.conf -sha256

openssl genrsa -out healthcheck-client.key 2048
openssl req -new -key healthcheck-client.key -out healthcheck-client.csr -config server.conf \
   -subj '/O=system:masters/CN=kube-etcd-healthcheck-client'
openssl x509 -req -in healthcheck-client.csr -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out healthcheck-client.crt -days 10000 \
    -extensions v3_ext -extfile server.conf -sha256
    
cp ca.crt /etc/kubernetes/pki/etcd
cp {server,peer,healthcheck-client}.{key,crt} /etc/kubernetes/pki/etcd