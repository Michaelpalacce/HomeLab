# Preface
<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="150px" alt="">

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager ). 
This repository contains basic HELM local charts for application installation as well as FluxCD2 HelmReleases for CI/CD. I'm not going to move away from the local helm charts where possible as they make this 
repository pretty beginner friendly. 

# Image updates 
Image updates are done via Renovate Bot :robot:. Renovate bot does periodic scans for new image versions and submits pull request for each change. 

# :open_book: Check out the Documentation
* [Documentation](./docs)

# :checkered_flag: Getting Started
1. [Prerequisites](./docs/Prerequisites.md)
2. [ClusterSetup](./docs/ClusterSetup.md)

# CI/CD :construction:
Gitops is applied wherever possible using Flux2. 
CI/CD is done by bootstrapping flux into my cluster. Flux polls github for changes and applies them automatically on my server.
It is currently pretty stable and works fine 

# :desktop_computer: Exposing Apps
As a legacy approach I used to expose my apps via NodePort. This ability is removed but can be easily enabled by 
removing the commented out nodePort values in the Helm Charts, and I also try to add this functionality to future apps 
and services I install. 

All the available nodePorts can be checked [here](./docs/Ports.md)

Apps are currently exposed by ingress-nginx and have SSL certificates provided by cert-manager.
A wildcard certificate is issued for my domain `*.stefangenov.site` and when the secret is created
 it is replicated in all namespace as `ingress` to be consumed by the ingress resources. This replication is needed because `Let's encrypt` rate limits certificate requests. 
