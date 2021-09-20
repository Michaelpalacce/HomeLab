This chart setups Longhorn storage.


Setting up S3 backup:

Create aws access keys that have access to s3

~~~
kubectl create secret generic aws-secret \
    --from-literal=AWS_ACCESS_KEY_ID=<your-aws-access-key-id> \
    --from-literal=AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key> \
    -n longhorn-system
~~~

Go to longhorn ui and add navigate to Settings > Backup

Backup Target: `s3://sgenov-backup@eu-west-1/` /// `s3://<bucket-name>@<region>/`
Backup Target Credential Secret: `aws-creds`
