#!/usr/bin/env bash
cd "$(dirname "$0")"
pwd
cp ../openssl/ca* . 
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 -o cfssl
chmod +x cfssl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64 -o cfssljson
chmod +x cfssljson
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl-certinfo_1.5.0_linux_amd64 -o cfssl-certinfo
chmod +x cfssl-certinfo
mv cfssl* /usr/local/bin

export IP=$(hostname -i |sed 's/[^ ]* //')

sh -c "sed -i -e 's/172.18.0.2/${IP}/g' server-csr.json"
sh -c "sed -i -e 's/172.18.0.2/${IP}/g' healthcheck-client-csr.json"

cp ca.crt /etc/kubernetes/pki/etcd/ca.crt

cfssl gencert -ca=ca.crt -ca-key=ca.key \
     --config=ca-config.json -profile=server \
     server-csr.json | cfssljson -bare server
mv server-key.pem /etc/kubernetes/pki/etcd/server.key
mv server.pem /etc/kubernetes/pki/etcd/server.crt

cfssl gencert -ca=ca.crt -ca-key=ca.key \
     --config=ca-config.json -profile=server \
     server-csr.json | cfssljson -bare peer   
mv peer-key.pem /etc/kubernetes/pki/etcd/peer.key
mv peer.pem /etc/kubernetes/pki/etcd/peer.crt

cfssl gencert -ca=ca.crt -ca-key=ca.key \
     --config=ca-config.json -profile=server \
     healthcheck-client-csr.json | cfssljson -bare healthcheck-client
mv healthcheck-client-key.pem /etc/kubernetes/pki/etcd/healthcheck-client.key
mv healthcheck-client.pem /etc/kubernetes/pki/etcd/healthcheck-client.crt


sh -c "sed -i -e 's/${IP}/172.18.0.2/g' server-csr.json"
sh -c "sed -i -e 's/${IP}/172.18.0.2/g' healthcheck-client-csr.json"