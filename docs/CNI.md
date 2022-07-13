# Reference
[Official Documentation](https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm)

# Steps

1. `helm repo add projectcalico https://projectcalico.docs.tigera.io/charts`
2. `helm install calico projectcalico/tigera-operator --version v3.23.2 --namespace tigera-operator`