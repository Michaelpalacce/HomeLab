# Backups
You can use a longhorn backup. NOTE: XFS does not work correctly with backups. IF you are using a xfs drive, longhorn
is not the way.

# Postgresql

### Backing up
Postgresql can be backed up via:  ( change the app=postgresql to postgresql14 to backup postgresql14 )
* `sudo kubectl exec -n postgresql $(sudo kubectl get po -n postgresql -l app=postgresql | awk 'NR>1{ print $1 }') -- pg_dumpall --file "/Backup" --host "localhost" --port "5432" --username "postgres" --no-password --database "postgres" --verbose --role "postgres" > /dev/null`
* `sudo kubectl exec -n postgresql $(sudo kubectl get po -n postgresql -l app=postgresql | awk 'NR>1{ print $1 }') -- cat /Backup > /tmp/Backup` ( kubeclt cp has issues with big files )
Then you can Backup /tmp/Backup

### Restoring
Copy the dump to the postgresql pod  and run: `psql -f Backupfile -U postgres` and pray











