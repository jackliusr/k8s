#!/bin/bash

apt-mark unhold kubelet kubectl && \
	apt-get update && apt-get install -y kubelet=1.19.5-00 kubectl=1.19.5-00 && \
	apt-mark hold kubelet kubectl

systemctl daemon-reload

systemctl restart kubelet
