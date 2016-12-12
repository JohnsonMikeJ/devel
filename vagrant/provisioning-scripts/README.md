# Provisioning Scripts
wget, chmod, and run scipts for installing services and software on my Vagrant boxes

## yum-install-dnsmasq.sh
Installs dnsmasq and updates /etc/dnsmasq.conf and /etc/sysconfig/network-scripts/ifcfg-eth0

`$ wget https://raw.githubusercontent.com/JohnsonMikeJ/devel-enviro/master/vagrant/provisioning-scripts/yum-install-dnsmasq.sh`

`$ chmod +x yum-install-dnsmasq.sh`

`$ ./yum-install-dnsmasq.sh`
