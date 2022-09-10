# Installing Kubernetes

## K3S and why are we using it
- For raspberry pis who have limited resources we need something more minimalistic. k3s was made to run with limited resources in mind, so it seems like a good fit
- We will not be using traefik as I stuck with ingress-nginx

## Before installing anything
It is highly advisory to go to each helm chart values.yaml file and check the different options and modify them as you wish.
Things like ports, storage size etc. are good to be checked out. You may also want to check out the variables for the ansible scripts

## Setting up the cluster
- First thing we are going to do is navigate to the `./ansible` folder
- Set up your inventory file ( use mine as an example, the only thing different will probably be the IPs, 
but if you chose a different ansible user, make sure to modify accordingly ) **Note: This is not secure. 
Ideally you should either pass in your password every time or setup passwordless authentication**
- **If you did not fix the iptables**, ( when it comes to raspberry pis ) do it now: `ansible -i hosts/inventory -b -m shell -a "iptables -F && update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && reboot" all`
- Run `ansible-galaxy install -r playbooks/install/requirements.yml` to install all the needed ansible roles from Ansible Galaxy
- Run `ansible-playbook -i hosts/inventory playbooks/install/main.yml --tags preflight` At this point you have 
everything needed to set up kubernetes ( all the needed binaries )
- Run `ansible-playbook -i hosts/inventory playbooks/install/main.yml --tags setup` This will initialize the 
master on the master PI and add all the workers
- You should check the Troubleshooting options regarding svclb and enable container ip forwarding.