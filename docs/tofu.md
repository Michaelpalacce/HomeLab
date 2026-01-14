# Tofu Controller

The tofu controller allows me to apply my terraform config in a gitops way.

## Getting the tfstate

Ref: https://flux-iac.github.io/tofu-controller/use-tf-controller/backup-and-restore-a-Terraform-state/

```sh
WORKSPACE=default
NAME=homelab-iac

kubectl get secret tfstate-${WORKSPACE}-${NAME} \
  -ojsonpath='{.data.tfstate}' \
  | base64 -d | gzip -d > terraform.tfstate
```

## Restoring the tfstate

```sh
gzip terraform.tfstate

WORKSPACE=default
NAME=my-stack

kubectl create secret \
  generic tfstate-${WORKSPACE}-${NAME} \
  --from-file=tfstate=terraform.tfstate.gz \
  --dry-run=client -o=yaml \
  | yq e '.metadata.annotations["encoding"]="gzip"' - \
  > tfstate-${WORKSPACE}-${NAME}.yaml

kubectl apply -f tfstate-${WORKSPACE}-${NAME}.yaml
```

## Viewing the plan

You must set first

```diff
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: homelab-iac
  namespace: flux-system
spec:
  interval: 1m
  # approvePlan: auto
  path: ./
  sourceRef:
    kind: GitRepository
    name: homelab-iac
    namespace: flux-system
  varsFrom:
    - kind: Secret
      name: homelab-iac-secrets
+  storeReadablePlan: human
```

And then you can do:

```sh
tfctl show plan homelab-iac
```
