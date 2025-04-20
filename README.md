# Preface
<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="150px" alt="">

This repository contains basic HELM local charts for application installation as well as FluxCD2 HelmReleases for GitOps.
I'm not going to move away from the local helm charts where possible as they make this repository pretty beginner-friendly.

# :open_book: Check out the Documentation
* [Documentation](./docs)

# Main tools used
1. **FluxCD 2** - GitOps for my HomeLab.
2. **Renovate** - Checks for updates to actions, helm charts, helm releases, docker containers.
3. **ingress-nginx** - Kubernetes ingress. This is used to access services using reverse proxy instead of exposing them on a port.
4. **cert-manager + reflector** - cert-manager generates certificates for my services and reflector duplicates the generated ssl
certificate secret to all the namespaces. The secret is called `ingress`.
5. **Longhorn** - K8S native storage.
6. **Ansible** - Used to provision the architecture
7. **Velero** - K8S and PVC backup. Free and open source by VMware 
8. **MetalLB** - LoadBalancer for bare-metal k8s clusters

# GitOps :construction:
GitOps is applied wherever possible using Flux2.
CI/CD is done by bootstrapping flux into my cluster. Flux polls GitHub for changes and applies them automatically on my server.
It is currently pretty stable.

# Image updates
Image updates are done via Renovate Bot :robot:. Renovate bot does periodic scans for new image versions and submits pull request for each change.

# Accessing services ( ingress-nginx, cert-manager )
Apps are currently exposed by ingress-nginx and have SSL certificates provided by cert-manager.
A wildcard certificate is issued for my domain `*.sgenov.dev` and when the secret is created
it is replicated in all namespace as `ingress` to be consumed by the ingress resources. This replication is
needed because `Let's encrypt` rate limits certificate requests. 

## :desktop_computer: Exposing Apps
As a legacy approach I used to expose my apps via NodePort. This ability is removed but can be easily enabled by
removing the commented out nodePort values in the Helm Charts, and I also try to add this functionality to future apps
and services I install.

# Control Plane Load Balancing

I used DNS load balancing for the control plane. This is done by creating an A record for the control plane and pointing it to the IPs of the control plane nodes.
This is done because I don't have a load balancer in my homelab and I don't want to expose the control plane on a single node.

# Storage ( Longhorn )
Longhorn is a great replicated storage option with a great UI for better visualisation. It's fast and tailor made for 
k8s. Developed by the same people responsible for k3s/rancher and other great tools. [Official site](https://longhorn.io/)

# Backup ( Velero ) 
Velero allows me to back up selected namespaces and ( with the help of restic ) ship the data to different sources.
In my case I'm using the velero AWS plugin.

The velero backup runs on a schedule every day during the evening hours and I pay around ~ $7 each month, mainly due to Wasabi pricing for
1TB as a minimum. 

Check the docs for more information about velero, but overall I try to backup everything

# What if I don't want to use Flux
Well it's absolutely fine. You can go to `Helm/apps` and install any app you want ( e.g. `helm install media media -n media --create-namespace` ).
However things like ingress, cert-management, longhorn are handled only via Flux. Information on the helm chart that is
used can be found in the `helm-release.yaml` for the specific service. Let's look at an example:
~~~yaml
---
apiVersion: helm.toolkit.fluxcd.io/v2
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
            host: longhorn.sgenov.dev
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
        host: longhorn.sgenov.dev
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
