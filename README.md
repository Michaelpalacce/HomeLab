# Preface
<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="150px" alt="">

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager ). 
This repository contains basic HELM local charts for application installation as well as FluxCD2 HelmReleases for CI/CD.
Image updates are done via Renovate Bot :robot:. GitOps via FluxCD2 

# :open_book: Check out the Documentation
* [Documentation](./docs)

# :checkered_flag: Getting Started
1. [Prerequisites](./docs/Prerequisites.md)
2. [ClusterSetup](./docs/ClusterSetup.md)

# CI/CD :construction:
WORK IN PROGRESS 
CI/CD is done by bootstrapping flux into my cluster. Flux polls github for changes and applies them automatically on my server.


# :desktop_computer: Exposing Apps
As a legacy approach I used to expose my apps via NodePort. This ability is removed but can be easily enabled by 
removing the commented out nodePort values in the Helm Charts.

All the available nodePorts can be checked [here](./docs/Ports.md)

Otherwise, apps are exposed by NginxProxyManager.

WIP: Migrate to nginx-ingress and cert-manager