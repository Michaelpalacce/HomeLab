# Troubleshooting

## Cluster creation failed (or everything has gone to heck and I want to re-do it)
- Run the k3s uninstall script https://rancher.com/docs/k3s/latest/en/installation/uninstall/
- Rerun `ansible-playbook -i inventory playbooks/install/main.yml --tags setup -k`

## Grafana is giving an error
- Try deleting the prometheus data source and re-adding it ( there may be 2 data sources, grafana makes a mistake sometimes )

## Ansible is not connection/is slow/hangs
- God have mercy on your soul cause ain't nobody gonna help you ;(

## Longhorn storage has an issue
- Check if it's dns, if it's not dns, I suggest you redo the entire cluster

## Clearing up containerd
- Go to `./ansible`
- Run: `ansible -i hosts/inventory -m shell -a "k3s crictl rmp -a" -b all` To remove all pods that are not up and running
- Run: `ansible -i hosts/inventory -m shell -a "k3s crictl rmi --prune" -b all` To remove all images
- Run: `ansible -i hosts/inventory -m shell -a "k3s crictl rm -a" -b all`

## Orphaned pods.
There is a chance that you may have force deleted some pods or an error may have occurred. In that case a lot of orphaned pods volumes will be left without being deleted.

If you want a solution to this there is an `orphanedpodscleaner` app under `Helm/apps` that will deploy a daemonset to solve this issue.

## Wallabag doesn't want to work correctly, it's giving me a wallabag_internal_settings table is not created
Restarting the deployment helps. No idea why?

## Issues with Longhorn volumes mounting
* Check out: https://longhorn.io/kb/troubleshooting-volume-with-multipath/

## cgroup-gc
This is a helm chart that installs a daemonset that will be deployed on all nodes with the purpose of clearing up cgroups.
For more information: `https://serverfault.com/questions/976233/context-deadline-exceeded-preventing-pods-from-being-created-in-aks`

