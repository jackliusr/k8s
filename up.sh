#!/bin/bash

result=$( kind get clusters | grep -E '^kind$')
if [ -n "$result" ]; then 
  echo "exist"
else
  echo "no exists"
  kind create cluster --config ./configs/$1-cluster.yaml
  if [ $? -eq 0 ] ; then
    if [[ -f ./configs/$1-hook.sh ]]; then 
      source ./configs/$1-hook.sh
    fi

    docker exec -d kind-control-plane  /mnt/configs/common/kubeconfig-config.sh
  else
    echo "failed to create cluster"
  fi
fi 
