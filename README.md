# Preface
<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="150px" alt="">

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager ). 
This repository contains basic HELM local charts for application installation as well as FluxCD2 HelmReleases for CI/CD. I'm not going to move away from the local helm charts where possible as they make this 
repository pretty beginner friendly.

# :open_book: Check out the Documentation
* [Documentation](./docs)

# :checkered_flag: Getting Started
1. [Prerequisites](./docs/Prerequisites.md)
2. [Cluster Setup](./docs/ClusterSetup.md)
3. [Cert Manager](./docs/SettingUpCertManager.md)
4. [Setting Up Renovate](./docs/SettingUpRenovate.md)
5[Backups](./docs/Backups.md)

# Main tools used
1. **FluxCD 2** - GitOps for my HomeLab.
2. **Renovate** - Checks for updates to actions, helm charts, helm releases, docker containers.
3. **ingress-nginx** - Kubernetes ingress. This is used to access services using reverse proxy instead of exposing them on a port.
4. **cert-manager + reflector** - cert-manager generates certificates for my services and reflector duplicates the generated ssl
certificate secret to all the namespaces. The secret is called `ingress`.
5. **Longhorn** - K8S native storage.
6. **SimpleSecrets** - Kubernetes secret manager.
7. **Calico** - Provides Networking for my HomeLab
8. **Ansible** - Used to provision the architecture
9. **Velero** - K8S and PVC backup. Free and open source by VMware 
10. **Kube-vip** - For a Virtual IP that I can use to access all my servers

# GitOps :construction:
GitOps is applied wherever possible using Flux2.
CI/CD is done by bootstrapping flux into my cluster. Flux polls GitHub for changes and applies them automatically on my server.
It is currently pretty stable and works fine

# Image updates
Image updates are done via Renovate Bot :robot:. Renovate bot does periodic scans for new image versions and submits pull request for each change.

# Accessing services ( ingress-nginx, cert-manager )
Apps are currently exposed by ingress-nginx and have SSL certificates provided by cert-manager.
A wildcard certificate is issued for my domain `*.stefangenov.site` and when the secret is created
it is replicated in all namespace as `ingress` to be consumed by the ingress resources. This replication is
needed because `Let's encrypt` rate limits certificate requests. 

#### :desktop_computer: Exposing Apps
As a legacy approach I used to expose my apps via NodePort. This ability is removed but can be easily enabled by
removing the commented out nodePort values in the Helm Charts, and I also try to add this functionality to future apps
and services I install.

# Storage ( Longhorn )
Longhorn is a great replicated storage option with a great UI for better visualisation. It's fast and tailor made for 
k8s. Developed by the same people responsible for k3s/rancher and other great tools. [Official site](https://longhorn.io/)

# Networking ( Calico CNI )
Calico is a great and mature CNI/IPAM software that is fast, scalable and feature rich. [Source code](https://github.com/projectcalico/calico)

# SimpleSecrets ( Secrets Management )
This is a tool that I've been developing in my spare time. **It is not audited or tested by security professionals !**
It allows for you to store secrets via the UI/API and create K8S Secrets by creating a SimpleSecrets object instead, allowing
me to commit `SimpleSecrets` to git, while not exposing anything to the internet.

# Backup ( Velero ) 
Velero allows me to backup selected namespaces and ( with the help of restic ) ship the data to different sources. 
In my case I'm using the velero AWS plugin. 

The velero backup runs on a schedule every day during the evening hours. 

# What if I don't want to use Flux
Well it's absolutely fine. You can go to `Helm/apps` and install any app you want
( e.g. `helm install media media -n media --create-namespace ). However things like ingress, cert-management, storage
are handled only via Flux. Information on the helm chart that is used can be found in the `
helm-release.yaml` for the specific service. Let's look at an example:
~~~yaml
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
    name: longhorn-system # What to call the deployment 
    namespace: longhorn-system # Where to install the helm chart 
spec:
    interval: 5m # How often do we poll for changes
    install:
        createNamespace: true # Same as --create-namespace
    chart:
        spec:
            chart: longhorn # Which chart to use
            version: 1.2.4 # Which version of the chart
            interval: 5m
#           Where to find information for this chart ( in my case I have a HelmRepository defined in cluster/homelab/helm/longhorn-system
            sourceRef: 
                kind: HelmRepository 
                name: longhorn-system
                namespace: flux-system
#   Overwriting some values
    values:
        ingress:
            enabled: true
            host: longhorn.stefangenov.site
            ingressClassName: nginx
            tls: true
            tlsSecret: ingress

        service:
            ui:
                type: NodePort
                nodePort: 30030
~~~

This would be the same as:
1. Creating a new file with the content:

`values.yaml`:
~~~yaml
ingress:
    enabled: true
    host: longhorn.stefangenov.site
    ingressClassName: nginx
    tls: true
    tlsSecret: ingress

service:
    ui:
        type: NodePort
        nodePort: 30030
~~~
2. Running: `helm repo add longhorn https://charts.longhorn.io; helm repo update` to add the longhorn helm repo
3. Running: `helm install longhorn/longhorn --name longhorn --create-namespace -n longhorn-system -f values.yaml`
