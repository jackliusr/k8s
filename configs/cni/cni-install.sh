#!/bin/bash
CONTAINERD_VERSION="v1.5.2"
CNI_VERSION="v0.9.1"
CRICTL_VERSION="v1.21.0"
export ARCH=$(dpkg --print-architecture | sed 's/ppc64el/ppc64le/' | sed 's/armhf/arm/')
export CNI_TARBALL="${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz" 
export CNI_URL="https://github.com/containernetworking/plugins/releases/download/${CNI_TARBALL}" 
curl -sSL --retry 5 --output /tmp/cni.tgz "${CNI_URL}"
tar -C /opt/cni/bin -xzvf /tmp/cni.tgz
cp  /mnt/cni/weaveutil  /opt/cni/bin/weave-plugin-2.8.1
cd /opt/cni/bin
chmod +x weave-plugin-2.8.1
ln -s  weave-plugin-2.8.1 weave-ipam
ln -s  weave-plugin-2.8.1 weave-net