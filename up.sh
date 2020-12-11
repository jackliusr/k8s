#!/bin/bash

result=$( kind get clusters | grep -E '^kind$')
if [ -n "$result" ]; then 
  echo "exist"
else
  echo "no exists"
  kind create cluster --config ./configs/$1-cluster.yaml
  if [[ ./configs/$1-hook.sh ]]; then 
     source ./configs/$1-hook.sh
  fi
fi 
