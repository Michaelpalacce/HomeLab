This chart is used to install prometheus, grafana and node-exporter as a monitoring stack and grafana loki + promtail as a logging stack.

The processes are limited, so we don't steal all the resources of the PIs. 

Available scrapers:
- Node-Exporter: `https://github.com/prometheus/node_exporter`
- Speedtest
- Uptimekuma