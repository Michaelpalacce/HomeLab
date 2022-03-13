# Backups
Currently, I do my backups via node-red.

# Restores
Restorations can be done via the restore playbooks however they are very opinionated towards my output from NodeRed.
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags nodered`
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags changedetection`
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags nginxproxymanager`
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags vaultwarden`
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags simplesecrets`
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags postgresql`
`ansible-playbook -i hosts/inventory playbooks/restore/main.yml --tags trilium`
