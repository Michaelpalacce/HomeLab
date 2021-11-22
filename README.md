# Preface

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager )

### Hardware needed
- 4 Raspberry pi 4B 8GB
- 4x SSDs ( you can do SD cards but lord have mercy is it slow )
- MicroSD adapter to install the OS on the card
- Raspberry Pi case for better form factor
- the machine you are reading this from ;)

##### Optional:
- Fan Heatsink ( ~ 5-10 dollars each )
- Smaller memory heatsink ( ~ 2 dollars each )

# Setting up the PI

### Setting up the Raspberry pi Hardware wise
- Add all your heatsinks ( if any )
- Place the PIs in their cases
- I noticed a 15 degrees drop when I removed the raspberry pi case lid. I just placed it on it, leaving it to breathe a bit and that improved the internal temperature drastically

### Booting Ubuntu Server from a SSD
- So first thing you gotta do is you gotta have a spare raspbian OS sd card.
- Boot into raspbian os and update the system `sudo apt upgrade -y`
- Run: `sudo raspi-config` and change your bootloader version to latest, then change the boot order to boot from USB storage

### My SSD drive has UAS and it's not letting me boot
Oh boy are you in for a treat :)
- Now the problem here is not all manufacturers who claim UASP support actually do. The problem may also come from the enclosure.
- What I noticed is that if you ... ahem "connect the usb half-assed ( aka not fully connected )" the pi boots fine.
 ( easiest way to do this is to first boot it without anything and start slowly inserting the usb ). So do that and let the pi boot
- After that, login to the Ubuntu Server and run `lsusb`. Get the ID of your SSD ( make sure it's the SSD, it will be named accordingly )
- `sudo nano /etc/modprobe.d/blacklist.conf` and add a new directive `blacklist uas` somewhere in the file
- `echo options usb-storage quirks={{ID_OF_YOUR_SSD}}:u | sudo tee /etc/modprobe.d/ssd_quirks.conf`
- `sudo update-initramfs -u` wait for operation to finish and you should be safe to plug in the SSD all the way and boot.
- This should be all :) Pi will now boot from SSD

# Preparing the OS

### Software Prerequisites
- If you want to use WI-FI ( WPA2 - Personal ) instead of Ethernet: https://www.linuxbabe.com/command-line/ubuntu-server-16-04-wifi-wpa-supplicant
- All the RPIs should have a unique hostname 
~~~bash 
sudo hostnamectl set-hostname {something_unique}
~~~
- Setup openssh-server an ansible user and your admin user
~~~bash
sudo adduser {USERNAME_HERE} # Follow prompts
sudo adduser ansible # Follow prompts and set password to ansible as well
sudo usermod -aG sudo ansible # Make ansible user root
sudo usermod -aG sudo {USERNAME_HERE} # Make your own user root
sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt

sudo apt install -y openssh-server
sudo vi /etc/ssh/ssh_config
# Go down and add the following: `AllowUsers ansible ubuntu {USERNAME_HERE}
~~~
- Setup python 3.x ( if it isn't already )
~~~bash
sudo ln -s /usr/bin/python3 /usr/bin/python
~~~
- That's it. At this point you can abandon the raspberry pis and go to your own machine to continue setup :) 

### Kubernetes Networking Prerequisites:
There seems to be an issue with iptabels >= 1.8 with all the network CNIs I have used.
The only solution seems to be to use the legacy ip tables. The following command will ensure that we use the legacy iptables,
which are working fine with k3s

~~~ bash
# Make sure you are sudo
iptables -F && update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && reboot
~~~

### Software needed on your machine
- Ansible 2.9.x [Install Instructions for Ubuntu Server](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04)
  ( I am using WSL to run my commands )
- sshpass ( if you are going to use password based authentication for the RPIs which I am ). If you want better security then configure key based authentication.

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
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags init` Inits dashy, longhorn, traefik and cgroup-gc

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

### Setting up monitoring
- Run `ansible-playbook -i inventory playbooks/monitoring/main.yml` Initialize Prometheus and Grafana
- Go to http://{{CLUSTER_URI}}:30010
- Username: admin  Password: admin
- It will prompt you to change the password
- Go to Settings/DataSources and add a Prometheus Datasource
- Set URL to prometheus:9090
- Import the dashboard located in ./config/ by clicking on the plus and then import
- Go to the dashboard :) It will take a few minutes to populate data
- If you want to setup backing up with s3 read the `BACKUP` section

### Setting up Jenkins
- Run `ansible-playbook -i inventory playbooks/apps/jenkins/main.yml` Install Jenkins CI/CD.
- Go to http://{{CLUSTER_URI}}:30020
- Install all the kubernetes pluguins and any other plugins you may need.
- How to configure:
~~~
Name: Kubernetes
Kubernetes URL: <blank>
Kubernetes Namespace: jenkins-pi
Credentials: {{ADD new with Service Account}}
WebSocket: yes
Direct: no
Jenkins URL: http://{{CLUSTER_IP}}:30020 # had to put in my whole ip here, service name did not work
Jenkins tunnel: <blank>
# Add new pod template
name: whatever
namespace: jenkins-pi
labels: SomeLabel

#Add container template
name: jnlp
Docker Image: stefangenov/jenkins-agent-node:node-16.7 # I have made a custom Node image that runs for arm processors, but you can check my docker repo and make your own
Working directory: /home/jenkins/agent
Command to run: <blank>
arguments passed: <blank>
Allocate pseudo TTY: yes

#Scroll down and search for Service account
Service account: jenkins

# That should be all, but if you have different requirements you can set them up
~~~

# Setting up apps

### Setting up BabyBuddy
- Run `ansible-playbook -i inventory playbooks/apps/babybuddy/main.yml`

### Setting up postgresql
- Run `ansible-playbook -i inventory playbooks/apps/postgresql/main.yml`

### Setting up grocy
- Run `ansible-playbook -i inventory playbooks/apps/grocy/main.yml`

### Setting up n8n
- Setup: `Setting up postgresql`
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- Create new database n8n
- Create a new user n8n and give it permissions to the n8n db
- Run `ansible-playbook -i inventory playbooks/apps/n8n/main.yml`

### Setting up archivebox
- Run `ansible-playbook -i inventory playbooks/apps/archivebox/main.yml`

### Setting up wikijs
- Run `ansible-playbook -i inventory playbooks/apps/wikijs/main.yml`

### Setting up diagrams
- Run `ansible-playbook -i inventory playbooks/apps/diagrams/main.yml`

### Setting up UptimeKuma
- Run `ansible-playbook -i inventory playbooks/apps/uptimekuma/main.yml`

### Setting up storage ( syncthing + ServerEmulator )
- Run `ansible-playbook -i inventory playbooks/apps/storage/main.yml`
- Go to your other device and add this one for syncthing :)
- For ServerEmulator you can use the root:toor credentials

### Setting up Vikunja
- Setup: `Setting up postgresql`
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- Create new database vikunja
- Create a new user vikunja with pass vikunja and give it permissions to the vikunja db
- IF YOU WANT SMTP: Go to the vikunja Helm values and modify the smtp settings. Change enabled to true and enter your 
  email details ( please use an app password instead of your actual password to your mail client ). Note that gmail settings 
  are entered but you can choose to use any smtp client you wish
- Run `ansible-playbook -i inventory playbooks/apps/vikunja/main.yml`
- 
### Setting up Wallabag
- Setup: `Setting up postgresql`
- Wait for pgAdmin to be up and running, login with credentials specific in values.
- Add server. Hostname: `postgresql.postgresql`. Username: `postgresql`. Password: `postgresql`
- The wallabag docker image creates a postgresql user and db itself
- Make sure to edit the values.yaml and change the `domainName` to your own one.
- Run `ansible-playbook -i inventory playbooks/apps/wallabag/main.yml`

### Setting up Media Services
- Read `Helm/apps/media/README.md` on some of the decisions taken
- I have decided I will use a pi called `ubunutu-1` for this purpose
- Run `kubectl label no ubuntu-1 type=media`
- Run `ansible-playbook -i inventory playbooks/apps/media/main.yml`

# Ingress rules
##### dashy.local
##### vikunja.local
##### n8n.local
##### diagrams.local
##### wikijs.local
##### uptimekuma.local
##### babybuddy.local
##### wallabag.local
##### {{node_ip}}/traefik -> trafeik admin

# NodePorts in use

## Monitoring
#### Used Port range: 30010-30019
##### Grafana: 30010
##### Prometheus: 30011
##### UptimeKuma: 30012

## CI/CD
#### Used Port range: 30020-30029
##### Jenkins CI/CD: 30020

## Infrastructure 
#### Used Port range: 30030-30099 / 32222
##### Longhorn Storage: 30030
##### Rancher: 30031 -> http
##### Rancher: 30032 -> https
##### pgAdmin: 30033
##### Homer/Dashy ( Dashboard ): 32222
##### Jackett: 30034
##### Transmission: 30035

## Media
#### Used Port range: 31001 - 31050
##### Jellyfin: 31001
##### Readarr: 31002
##### Radarr: 31003
##### Sonarr: 31004

## Apps
#### Used Port range: 30100 - 31000
##### BabyBuddy: 30100
##### ServerEmulator: 30108
##### Vikunja: 30109
##### Syncthing: 30110
##### WikiJS: 30111
##### Grocy: 30112
##### Archivebox: 30113
##### N8N: 30114
##### Diagrams/Drawio: 30115
##### Wallabag: 30116

# Backups
You can use a longhorn backup. NOTE: XFS does not work correctly with backups. IF you are using a xfs drive, longhorn
is not the way.

# Experimental !!!!!!!!!!!!!!!!

### Installing rancher ( Manual process. I personally would not recommend it :) if you won't be installing apps )
* Run `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml` to install cert-manager that rancher needs
* Run `helm repo add rancher-stable https://releases.rancher.com/server-charts/stable`
* Run `helm repo update`
* Run `helm install rancher rancher-stable/rancher --namespace cattle-system --create-namespace --set hostname=rancher.local`
* Patch the rancher service to port 30031

# Increasing PVC/volume Size
Longhorn requires a few manual steps to achieve this.

## Steps:

1. Stop all pods the volume is attached to
1. Increase size of volume
1. Go to Longhorn UI
1. Attach the volume in maintenance mode
1. Wait for the resizing to finish
1. Start all pods

# Troubleshooting

### Cluster creation failed ( or everything has gone to heck and I want to re-do it)
- Run the k3s uninstall script https://rancher.com/docs/k3s/latest/en/installation/uninstall/
- Rerun `ansible-playbook -i inventory playbooks/install/main.yml --tags setup` 

### Grafana is giving an error
- Try deleting the prometheus data source and re-adding it ( there may be 2 data sources, grafana makes a mistake sometimes )

### Grafana stuck in ContainerCreating and storage is not being attached
- Only solution I found was recreating the cluster. Happened once to me

### Ansible is not connection/is slow/hangs
- God have mercy on your soul cause ain't nobody gonna help you ;(

### The pis are not connecting to the internet after reboot
- I also noticed this once after reboot, not sure why but fixing my resolv.conf to point to my router seems to have fixed the issue

### Longhorn storage has an issue
- Check if it's dns, if it's not dns, I suggest you redo the entire cluster

### Clearing up containerd
- Go to `./ansible`
- Run: `ansible -i inventory -m shell -a "k3s crictl rmp -a" -b all`
- Run: `ansible -i inventory -m shell -a "k3s crictl rmi --prune`
- Run: `ansible -i inventory -m shell -a "k3s crictl rm -a" -b all`

### Wallabag doesn't want to work correctly, it's giving me a wallabag_internal_settings talbe is not created
Restarting the deployment helps. No idea why?

### Issues with Longhorn volumes mounting
* Check out: https://longhorn.io/kb/troubleshooting-volume-with-multipath/

### Even more issues with Longhorn volume mounting
Some times in case of a lot of services being brought up Longhorn fails to resolve for hours.... What I found useful is 
changing the replicas to the failing services to zero and slowly increasing it to the desired amount one by one 

### Even even more issues with Longhorn 
Check if Longhorn nodes are up or down. If they are down, identify the manager that is failing and see why it is failing.
In a few cases it has been due to not being able to patch one volume, at that point you can scale down that service to 0 so it can start and later on start it back up and
all will be good.
