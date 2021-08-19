This chart is used to install prometheus with grafana.

The processes are limited so we don't steal all the resources of the PIs. 

Ideal values:
grafana -> 1Gi Memory
cAdvisor -> 2Gi Memory

Available scrapers:
- cAdvisor: `https://github.com/google/cadvisor`
- Node-Exporter: `https://github.com/prometheus/node_exporter`
