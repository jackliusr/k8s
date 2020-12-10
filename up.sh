#!/bin/bash

kind get clusters | grep -v '^kind$'

if [ $? ]; then 
  echo "no exist"
  kind create cluster --config ./configs/$1-cluster.yaml
  source ./configs/$1-hook.sh
else
  echo "exists"
fi 
