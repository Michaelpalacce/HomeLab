# Reference
[Official Documentation](https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm)

## Notes
Currently not in use

## Steps

1. `helm repo add projectcalico https://projectcalico.docs.tigera.io/charts`
2. `helm install calico projectcalico/tigera-operator --version v3.23.2 --namespace tigera-operator`
3. `kubectl apply -f docs/calico-cni.config.yaml`