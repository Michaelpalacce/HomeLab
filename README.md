# Preface

The purpose of this project is to setup my Kubernetes HomeLab environment

### Hardware needed
- 2 Raspberry pi 4S 8GB running Ubuntu Server with SSH Server and python
- the machine you are reading this from ;)

### Prerequisites
- All the RPIs should have a unique hostname `sudo hostnamectl set-hostname {something_unique}`
- RUN: `iptables -F && update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && reboot` If you want networking to work.

### Software needed
- Ansible 2.9.x [Install Instructions](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04)
- Python 3.x ( type python if you don't have it chances are you will be given the install command ), Make sure that python3 is the default python run when calling python otherwise it will fail `ln -s /usr/bin/python3 /usr/bin/python`
- sshpass ( if you are going to use password base authentication for the RPIs )

### Setting up the cluster
- First thing we are going to do is navigate to the `./setup` folder
- Setup your inventory file ( use mine as an example )
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags preflight` At this point you have everything needed to setup kubernetes ( all the needed binaries )
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags setup` This will initialize the master on the init_master PI
