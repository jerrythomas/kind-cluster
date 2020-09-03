#!/bin/bash
cluster=${1:-default}
reg_port=${2:-5000}
reg_name=kind-registry

if [ "$cluster" -eq "" ]
then 
   cluster="with-worker"
fi

exists=`kind get clusters | grep ${cluster} | wc -l`
if [ $exists -eq "0" ] 
then
  kind create cluster --name ${cluster} --config kind-config.yaml
else
  echo "kind cluster '${cluster}' exists, skipping"
fi
kubectl apply -f kind-registry.yaml
docker network connect "kind" "${reg_name}"

for node in $(kind get nodes --name "${cluster}"); do
  kubectl annotate node "${node}" "kind.x-k8s.io/registry=localhost:${reg_port}";
done