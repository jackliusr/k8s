#!/bin/bash

apt-get update &&  apt-get install -y gnupg2 apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
cat <<EOF |  tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update
apt-cache madison kubeadm 

apt-mark unhold kubeadm && \
	apt-get update && apt-get install -y kubeadm=1.19.5-00 && \
	apt-mark hold kubeadm


