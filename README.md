# Preface

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager )

# Check out the Documentation
* [Documentation](./docs)

# Getting Started
1. [Prerequisites](./docs/Prerequisites.md)
2. [ClusterSetup](./docs/ClusterSetup.md)

# Exposing Apps
As a legacy approach I used to expose my apps via NodePort. This ability is removed but can be easily enabled by 
removing the commented out nodePort values in the Helm Charts.

All the available nodePorts can be checked [here](./docs/Ports.md)

Otherwise apps are exposed by NginxProxyManager