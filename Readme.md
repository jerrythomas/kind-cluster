# Kind Cluster with registry

A simple script to create a kind cluster with a single worker node and registry.

```bash
git clone https://github.com/jerrythomas/kind-cluster
cd kind-cluster

./create-kind-cluster.sh
```

Uses port `5000` for the registry and the cluster name is set to `with-worker`. 

Alternatively the `kind-config.yaml` can be modified for additional options and the cluster name, registry port can be supplied as commandline parameters.

The command below will create the cluster with name `one-worker` and use the port `4000` for the kind-registry.

```bash
./create-kind-cluster.sh one-worker 4000
```
