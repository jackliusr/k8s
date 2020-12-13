#!/bin/bash
CONTAINERD_VERSION="v1.4.0-106-gce4439a8"
CNI_VERSION="v0.8.7"
CRICTL_VERSION="v1.19.0"
export ARCH=$(dpkg --print-architecture | sed 's/ppc64el/ppc64le/' | sed 's/armhf/arm/')
export CNI_TARBALL="${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz" 
export CNI_URL="https://github.com/containernetworking/plugins/releases/download/${CNI_TARBALL}" 
curl -sSL --retry 5 --output /tmp/cni.tgz "${CNI_URL}"
tar -C /opt/cni/bin -xzvf /tmp/cni.tgz
