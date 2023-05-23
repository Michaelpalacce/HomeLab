---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
    name: jackett
    namespace: media
    annotations:
        kubernetes.io/ingress.class: nginx
        gethomepage.dev/enabled: "true"
        gethomepage.dev/description: Torrent indexer
        gethomepage.dev/group: Torrents
        gethomepage.dev/icon: jackett
        gethomepage.dev/name: Jackett
        gethomepage.dev/widget.type: jackett
        gethomepage.dev/widget.url: https://jackett.stefangenov.site