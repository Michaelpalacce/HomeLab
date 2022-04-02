# Backups ( WIP )

Backups are done via [Velero](https://github.com/vmware-tanzu/velero).

## Installation:
1. Create a bucket in AWS S3 ( Mine is called `sgenov-backup` )
2. Create a IAM user with the correct policy for S3
3. Get the IAM user's credentials
4. Create a new file: `velero-credentials` in the root of the folder ( see how it should look down below )
5. In the project root, run: `velero install --use-restic --provider aws --plugins velero/velero-plugin-for-aws --bucket sgenov-velero-backup --secret-file ./velero-credentials --backup-location-config region=eu-west-1 --snapshot-location-config region=eu-west-1`
    1. Make sure the bucket is empty!
    2. --use-restic is used to backup PVCs

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


#### Manual:
1. Clear up namespace
2. Run `velero restore create uptimekuma1 --from-backup uptimekuma --restore-volumes=true`

#### From Schedule:
1. Clear up any resources you wish to backup
2. Run: `velero restore create --from-schedule general --restore-volumes=true`. Optionally add: `--include-namespaces postgresql`