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
