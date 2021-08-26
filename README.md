# Preface

The purpose of this project is to setup my Kubernetes HomeLab environment on a Raspberry PI 4s backbone.
The OS used is an Ubuntu server 21.04 x64 arm64 ISO ( downloaded from the Raspberry pi Imager )

### Hardware needed
- 2 Raspberry pi 4S 8GB
- 2x SSDs ( you can do SD cards but lord have mercy is it slow )
- MicroSD adapter to install the OS on the card
- Raspberry Pi case for better form factor
- the machine you are reading this from ;)

##### Optional:
- Fan Heatsink ( ~ 10 dollars each )
- Smaller memory heatsink ( ~ 2 dollars each )

### Setting up the Raspberry pi Hardware wise
- Add all your heatsinks ( if any )
- Place the PIs in their cases
- I noticed a 15 degrees drop when I removed the raspberry pi case lid. I just placed it on it, leaving it to breathe a bit and that improved the internal temperature drastically

### Booting Ubuntu Server from a SSD
- So first thing you gotta do is you gotta have a spare raspbian OS sd card.
- Boot into raspbian os and update the system `sudo apt upgrade -y`
- Run: `sudo raspi-config` and change your bootloader version to latest, then change the boot order to boot from USB storage

### My SSD drive has UAS
Oh boy are you in for a treat :)
- What I noticed is that if you ... ahem "connect the usb half-assed ( aka not fully connected )" the pi boots fine 
 ( easiest way to do this is to first boot it without anything and start slowly inserting the usb ). So do that and let the pi boot
- After that, login to the Ubuntu Server and run `lsusb`. Get the ID of your SSD
- `sudo nano /etc/modprobe.d/blacklist.conf` and add a new directive `blacklist uas`
- `echo options usb-storage quirks={{ID_OF_YOUR_SSD}}:u | sudo tee /etc/modprobe.d/blacklist_uas.conf`
- `sudo update-initramfs -u`
- This should be all :) Pi will now boot from SSD


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

### Setting up the cluster
- First thing we are going to do is navigate to the `./ansible` folder
- Set up your inventory file ( use mine as an example, the only thing different will probably be the IPs, but if you chose a different ansible user, make sure to modify accordingly )
- If you did not fix the iptables, do it now: `ansible -i inventory -b -m shell -a "iptables -F && update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && reboot" all`
- Run `ansible-galaxy install -r playbooks/install/requirements.yml` to install all the needed ansible roles from Ansible Galaxy
- Run `ansible-galaxy collection install -r playbooks/install/requirements-collecttions.yml` to install all the needed ansible collections
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags preflight` At this point you have everything needed to setup kubernetes ( all the needed binaries )
- Run `ansible-playbook -i inventory playbooks/install/main.yml --tags setup` This will initialize the master on the init_master PI
- Run `ansible-playbook -i inventory playbooks/longhorn-storage/main.yml` Initialize longhorn storage
- Run `ansible-playbook -i inventory playbooks/monitoring/main.yml` Initialize Prometheus and Grafana
- Run `ansible-playbook -i inventory playbooks/jenkins/main.yml` Install Jenkins CI/CD. 
- Run `kubectl exec --namespace jenkins-pi -it svc/jenkins-pi -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo` to get the jenkins password

### Setting up grafana dashboard
- Go to http://{{CLUSTER_URI}}:30100
- Username: admin  Password: admin
- It will prompt you to change the password
- Go to Settings/DataSources and add a Prometheus Datasource
- Set URL to prometheus:9090
- Import the dashboard located in ./config/ by clicking on the plus and then import
- Go to the dashboard :) It will take a few minutes to populate data


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
