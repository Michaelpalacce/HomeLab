# Hardware

### Hardware needed
* 4 Raspberry pi 4B 8GB
* 4x SSDs ( you can do SD cards but lord have mercy is it slow )
* MicroSD adapter to install the OS on the card
* Raspberry Pi case for better form factor
* Synology NAS/Other NAS server
* the machine you are reading this from ;)

### Optional:
* Fan Heatsink ( ~ 5-10 dollars each )
* Smaller memory heatsink ( ~ 2 dollars each )

### Setting up the Raspberry pi Hardware wise
* Add all your heatsinks ( if any )
* Place the PIs in their cases
* I noticed a 15 degrees drop when I removed the raspberry pi case lid. I just placed it on it, leaving it to breathe a bit and that improved the internal temperature drastically

# Software

### Booting Ubuntu Server from a SSD
* So first thing you gotta do is you gotta have a spare raspbian OS sd card.
* Boot into raspbian os and update the system `sudo apt upgrade -y`
* Run: `sudo raspi-config` and change your bootloader version to latest, then change the boot order to boot from USB storage

### My SSD drive has UAS and it's not letting me boot
Oh boy are you in for a treat :)
* Now the problem here is not all manufacturers who claim UASP support actually do. The problem may also come from the enclosure.
* What I noticed is that if you ... ahem "connect the usb half-assed ( aka not fully connected )" the pi boots fine.
  ( easiest way to do this is to first boot it without anything and start slowly inserting the usb ). So do that and let the pi boot
* `sudo nano /etc/modprobe.d/blacklist.conf` and add a new directive `blacklist uas` somewhere in the file
* After that, login to the Ubuntu Server and run `lsusb`. Get the ID of your SSD ( make sure it's the SSD, it will be named accordingly )
* `echo options usb-storage quirks=152d:0562:u | sudo tee /etc/modprobe.d/ssd_quirks.conf` where 152d:0562 was my ID I got from lsusb
* `echo options usb-storage quirks=152d:0578:u | sudo tee /etc/modprobe.d/ssd_quirks.conf` where 152d:0578 was my ID I got from lsusb
* `sudo update-initramfs -u` wait for operation to finish and you should be safe to plug in the SSD all the way and boot.
* This should be all :) Pi will now boot from SSD

### Software Prerequisites
* If you want to use WI-FI ( WPA2 - Personal ) instead of Ethernet: https://www.linuxbabe.com/command-line/ubuntu-server-16-04-wifi-wpa-supplicant
* All the RPIs should have a unique hostname
~~~bash 
sudo hostnamectl set-hostname {something_unique}
~~~
* Setup an ansible user and do a fix for cgroups
~~~bash
sudo adduser ansible # Follow prompts and set password to ansible as well
sudo usermod -aG sudo ansible # Make ansible user root
sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt
~~~
* That's it. At this point you can abandon the raspberry pis and go to your own machine to continue setup :)

### Kubernetes Networking Prerequisites:
There seems to be an issue with iptables >= 1.8 with all the network CNIs I have used.
The only solution seems to be to use the legacy ip tables. The following command will ensure that we use the legacy iptables,
which are working fine with k3s

~~~ bash
# Make sure you are sudo
iptables -F && update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && reboot
~~~

### Software needed on your machine
* Ansible 3.9.x [Install Instructions for Ubuntu Server](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04)
  ( I am using WSL to run my commands )
* sshpass ( if you are going to use password based authentication for the RPIs which I am ). If you want better security then configure key based authentication.

### Services that need to be setup
* Pi-Hole setup 
