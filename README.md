# Preface

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager )

# WORK IN PROGRESS CONTENT TABLE
* [Prerequisites](./docs/Prerequisites.md)
* [Getting Started](./docs/GettingStarted.md)

### Software needed on master ( or a separate device )
- Pi-Hole setup 

### K3S and why are we using it
- For raspberry pis who have limited resources we need something more minimalistic. k3s was made to run with limited resources in mind, so it seems like a good fit
- We will not be using traefik and flannel tho as they seem to result in a DNS issue I could not resolve, so I stuck with the classic -> calico :)

# Installing Kubernetes

### Before installing anything
It is highly advisory to go to each helm chart values.yaml file and check the different options and modify them as you wish.
Things like ports, storage size etc are good to be checked out. You may also want to check out the variables for the ansible scripts

### Where are my services 
If you scroll down a bit you will find a list of ports that the services are running on

### Setting up the cluster
- First thing we are going to do is navigate to the `./ansible` folder
- Set up your inventory file ( use mine as an example, the only thing different will probably be the IPs, but if you chose a different ansible user, make sure to modify accordingly )
- If you did not fix the iptables, do it now: `ansible -i inventory -b -m shell -a "iptables -F && update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && reboot" all`
- Run `ansible-galaxy install -r playbooks/install/requirements.yml` to install all the needed ansible roles from Ansible Galaxy
- Run `ansible-galaxy collection install -r playbooks/install/requirements-collections.yml` to install all the needed ansible collections
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags preflight` At this point you have everything needed to setup kubernetes ( all the needed binaries )
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags setup` This will initialize the master on the init_master PI and add all the workers
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags init` Inits longhorn, nginxproxymanager and cgroup-gc

### cgroup-gc
This is a helm chart that installs a daemonset that will be deployed on all nodes with the purpose of clearing up cgroups.
For more information: `https://serverfault.com/questions/976233/context-deadline-exceeded-preventing-pods-from-being-created-in-aks`

### Dashboard
By default dashy is installed. However dashy has a costly init and takes a while before it is actually applied. If you
have limited resources, you may need to use homer instead. You can change the variable in `playbooks/install/vars/main.yml` of dashboard to `homer`

You can always reapply the dashboard after that with: `ansible-playbook -i inventory playbooks/install/main.yml --tags "dashboard"`. You will have to manually uninstall the other
dashboard!

### Adding new workers after cluster has been run
- Follow all the same prerequisite steps as for the other workers
- Modify the inventory file to add the new worker to the other workers
- Run: `ansible-playbook -i inventory playbooks/install/main.yml --tags preflight`
- Run: `ansible-playbook -i inventory playbooks/install/main.yml --tags setup`
