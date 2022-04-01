# Flux

### Flux bootstrap
1. Add env variable GITHUB_TOKEN
2. Run: `flux bootstrap github --owner=Michaelpalacce --repository=HomeLab --branch=master --path=./cluster/homelab/base --personal`
3. Flux needs to run a reconciliation after which it will bootstrap the cluster with all apps in order. 
   1. Note: **This will take a while**

### How does it work?
`cluster/homelab/base` is the entrypoint. It holds Kustomizations for all the other 3 modules as well as the flux-system ( which is the flux installation )
Each Kustomization is a separate file with dependencies of one another.

#### Steps of import:
1. `helm.yaml` - Holds all the helm charts needed.
2. `core.yaml` - Depends on helm Kustomization and holds core functionality for the cluster to function like storage, certificates, ingress, etc.
3. `apps.yaml` - Depends on both `core.yaml` and `helm.yaml` and holds all the apps currently installed on my cluster.








