#!/bin/bash

usage() {
  echo "Usage: $0 <config-name>"
  echo "       $0 list"
  echo ""
  echo "Creates a Kind cluster using the configuration and hooks in ./configs/"
  echo ""
  echo "Commands:"
  echo "  config-name   Name of the cluster configuration (e.g., 2nodes, 4nodes, cilium)"
  echo "  list          List all available cluster configurations"
  echo ""
  echo "Examples:"
  echo "  $0 2nodes"
  echo "  $0 cilium-lb"
  echo "  $0 list"
  exit 1
}

list_configs() {
  echo "Available cluster configurations:"
  echo ""
  for f in ./configs/*-cluster.yaml; do
    name=$(basename "$f" -cluster.yaml)
    hook="./configs/${name}-hook.sh"
    if [ -f "$hook" ]; then
      echo "  $name  (with hook)"
    else
      echo "  $name"
    fi
  done
}

if [ $# -lt 1 ]; then
  usage
fi

if [ "$1" = "list" ]; then
  list_configs
  exit 0
fi

config_file="./configs/$1-cluster.yaml"
if [ ! -f "$config_file" ]; then
  echo "Error: Configuration file '$config_file' not found."
  usage
fi

result=$( kind get clusters | grep -E '^kind$')
if [ -n "$result" ]; then 
  echo "the kind cluster existed. Do you want to delete it (y/n)?"
  read -p "Is this a good question (y/n)? " answer
  case ${answer:0:1} in
      y|Y )
          kind delete cluster
      ;;
      * )
          return
      ;;
  esac  
fi


kind create cluster --config "$config_file"
if [ $? -eq 0 ] ; then
  if [[ -f ./configs/$1-hook.sh ]]; then 
    source ./configs/$1-hook.sh
  fi

  docker exec -d kind-control-plane  /mnt/configs/common/kubeconfig-config.sh
else
  echo "failed to create cluster"
fi
 
