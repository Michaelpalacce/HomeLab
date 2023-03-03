# Backups

Backups are done via [Velero](https://github.com/vmware-tanzu/velero).

Currently, my backups are done using the Velero helm chart. 
A Velero Schedule Custom resource is created for every day at 5 in the morning that backups a bunch of my services.


# Manual steps and General Knowledge :

## Installation:
1. Create a bucket in AWS S3 ( Mine is called `sgenov-backup` )
2. Create a IAM user with the correct policy for S3
3. Get the IAM user's credentials
4. Create a new file: `velero-credentials` in the root of the folder ( see how it should look down below )
5. In the project root, run: `velero install --use-restic --provider aws --plugins velero/velero-plugin-for-aws --bucket sgenov-velero-backup --secret-file ./velero-credentials --backup-location-config region=eu-west-1 --snapshot-location-config region=eu-west-1`
    1. Make sure the bucket is empty!
    2. --use-restic is used to back up PVCs

`velero-credentials`:
~~~
[default]
aws_access_key_id=<AWS_ACCESS_KEY_ID>
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
~~~

## Creating backups:

#### Manual:
`velero backup create uptimekuma --include-namespaces uptimekuma --snapshot-volumes=true` Will backup the namespace uptimekuma

#### From Schedule:
`velero create backup --from-schedule general`


## Restoring backups:

When restoring backups Velero will not restore objects that are already existing, so whatever you need to restore must be deleted first.
If you are restoring pods from a deployment/statefulset/daemonsets/etc make sure to delete them too. 

**NOTE:** Velero will hang up if it can't restore all the restic volumes, so you may need to remove the restore or it will be stuck in `In progress`

#### Manual:
1. Clear up namespace
2. Run `velero restore create uptimekuma1 --from-backup uptimekuma --restore-volumes=true`. Optionally add: `--include-namespaces postgresql`

#### From Schedule:
1. Clear up any resources you wish to restore
2. Run: `velero restore create --from-schedule general --restore-volumes=true`. Optionally add: `--include-namespaces postgresql`

***
***
***
***
***
***
# *OLD way of handling backup and restore*:
# Backups
Currently, I do my backups via node-red. Reason why I don't go for another solution is because I have not found a good
FOSS to do what I want to do. I know that K10 is more than enough for me but even so I don't want to rely on proprietary
software.

# Restores
Restorations can be done via the restore playbooks however they are very opinionated towards my output from NodeRed.
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags nodered`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags changedetection`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags nginxproxymanager`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags vaultwarden`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags simplesecrets`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags postgresql`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags trilium`
* `ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags uptimekuma`
