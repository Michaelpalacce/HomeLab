# Troubleshooting

### Cluster creation failed ( or everything has gone to heck and I want to re-do it)
- Run the k3s uninstall script https://rancher.com/docs/k3s/latest/en/installation/uninstall/
- Rerun `ansible-playbook -i inventory playbooks/install/main.yml --tags setup`

### Grafana is giving an error
- Try deleting the prometheus data source and re-adding it ( there may be 2 data sources, grafana makes a mistake sometimes )

### Grafana stuck in ContainerCreating and storage is not being attached
- Only solution I found was recreating the cluster. Happened once to me

### Ansible is not connection/is slow/hangs
- God have mercy on your soul cause ain't nobody gonna help you ;(

### The pis are not connecting to the internet after reboot
- I also noticed this once after reboot, not sure why but fixing my resolv.conf to point to my router seems to have fixed the issue

### Longhorn storage has an issue
- Check if it's dns, if it's not dns, I suggest you redo the entire cluster

### Clearing up containerd
- Go to `./ansible`
- Run: `ansible -i inventory -m shell -a "k3s crictl rmp -a" -b all` To remove all pods that are not up and running
- Run: `ansible -i inventory -m shell -a "k3s crictl rmi --prune" -b all` To remove all images
- Run: `ansible -i inventory -m shell -a "k3s crictl rm -a" -b all`

### Orphaned pods.
There is a chance that you may have force deleted some pods or an error may have occurred. In that case a lot of orphaned pods volumes will be left without being deleted.

If you want a solution to this there is an `orphanedpodscleaner` app under `Helm/apps` that will deploy a daemonset to solve this issue.

### Wallabag doesn't want to work correctly, it's giving me a wallabag_internal_settings table is not created
Restarting the deployment helps. No idea why?

### Issues with Longhorn volumes mounting
* Check out: https://longhorn.io/kb/troubleshooting-volume-with-multipath/

### Even more issues with Longhorn volume mounting
Some times in case of a lot of services being brought up Longhorn fails to resolve for hours.... What I found useful is
changing the replicas to the failing services to zero and slowly increasing it to the desired amount one by one

### Even even more issues with Longhorn
Check if Longhorn nodes are up or down. If they are down, identify the manager that is failing and see why it is failing.
In a few cases it has been due to not being able to patch one volume, at that point you can scale down that service to 0 so it can start and later on start it back up and
all will be good.

### Missing iscsi_tcp kernel module
Run: `apt install -y linux-modules-extra-raspi && echo 'iscsi_tcp' >> /etc/modules`. Reboot and it should be loaded

### High CPU Usage udisksd
After around 4-5 months of debugging I figured out that using my current setup if I issue too many mount commands ( readiness and liveness probes do that )
leads to udisksd reaching 100% cpu. Nothing else I tried helped, so this is why I only have some basic readiness and liveness probes