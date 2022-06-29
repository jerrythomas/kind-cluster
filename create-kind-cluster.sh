#!/bin/bash
cluster=${1:-with-worker}
reg_port=${2:-5000}
reg_name=kind-registry
provider=${3:-podman}

if [ ${provider} != "docker" ] && [ ${provider} != "podman" ]; then
  echo "Unknown provider: ${provider}" && exit 1;
fi
# create registry container unless it already exists
running="$(${provider} inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"
if [ "${running}" != 'true' ]; then
  ${provider} run \
    -d --restart=always -p "${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

exists=`kind get clusters | grep ${cluster} | wc -l`
if [ $exists -eq "0" ]
then
  kind create cluster --name ${cluster} --config kind-config.yaml
else
  echo "kind cluster '${cluster}' exists, skipping"
fi

rm -f kind-registry.yaml
sed "s/PORT/${reg_port}/" kind-registry-template.yaml > kind-registry.yaml
kubectl apply -f kind-registry.yaml
${provider} network connect "kind" "${reg_name}"

for node in $(kind get nodes --name "${cluster}"); do
  kubectl annotate node "${node}" "kind.x-k8s.io/registry=localhost:${reg_port}";
done
