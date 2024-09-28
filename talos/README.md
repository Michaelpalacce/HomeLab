# Purpose

I will be going through the process of migrating away from ansible and k3s and fully embracing Talos Linux. I will be using Terraform to provision the infrastructure and Talos Linux to manage the Kubernetes cluster.

# Roadmap

- [ ] Terraform for Proxmox to provision the Talos Machines
- [ ] CNI, maybe Cilium
- [ ] CSI/Longhorn Support
- [ ] Shared IP for the Control Plane
- [ ] LB
- [ ] Path to upgrade Kubernetes
- [ ] Path to upgrade Talos
- [ ] Ingress Controller
- [ ] Certificate management 
- [ ] GitOps

# Terraform For Proxmox

I will be using Terraform to provision the infrastructure on Proxmox.

## Links

- https://www.talos.dev/v1.8/talos-guides/install/virtualized-platforms/proxmox/


# CNI

Talos comes with Flannel built in. I have used Flannel before, but it's very bare bones and I am looking for something a bit more advanced. I am considering Cilium.

Cilium also offers a Gateway API implementation.

## Links

- https://www.talos.dev/v1.8/kubernetes-guides/network/deploying-cilium/


# CSI

Longhorn will be used for the CSI.

- May not be the best choice, as it writes in the ephemeral storage of the nodes and I have to pass `--preserve` when upgrading the nodes,
  which is not ideal.
- Pod security policies need to be applied per namespace.

## Links

- https://longhorn.io/docs/1.7.1/advanced-resources/os-distro-specific/talos-linux-support/

# Shared IP for the Control Plane

## Links

- https://www.talos.dev/v1.8/talos-guides/network/vip/

# Load Balancer

# Path to upgrade Kubernetes

# Path to upgrade Talos

## Links

- https://www.talos.dev/v1.8/talos-guides/upgrading-talos/

# Ingress Controller

# Certificate Management

# GitOps

