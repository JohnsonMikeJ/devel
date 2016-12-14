#!/bin/sh

# Simple script to install dnsmasq (lightweight caching dns nameserver) and enable
#  .localhost, .example, .invalid; and .localhost.
#
# This script was designed to install dnsmasq on my CentOS Vagrant box.
# @see https://github.com/JohnsonMikeJ/devel-enviro/tree/master/vagrant/centos-6.8-min-x86_64
#
# @link https://github.com/JohnsonMikeJ/devel-enviro/tree/master/vagrant/provisioning-scripts/yum-install-dnsmasq.sh
#
# Author: Mike Johnson <mike.johnson@highimpacttech.com>
#
# Date: 2016-12-11
#

# Exit on any error
set -e

echo -e "Updating Yum ..."
sudo yum update

echo -e "Installing dnsmasq ..."
sudo yum install -y dnsmasq

echo -e "Starting dnsmasq ..."
sudo service dnsmasq start

echo -e "Enabling chkconfig for dnsmasq ..."
sudo chkconfig dnsmasq on

echo -e "Adding .localhost, .example, .invalid; and .localhost to /etc/dnsmasq.conf ..."
sudo sed -i '/address=\/doubleclick.net/a address=\/test\/127.0.0.1\naddress=\/example\/127.0.0.1\naddress=\/invalid\/127.0.0.1\naddress=\/localhost\/127.0.0.1' /etc/dnsmasq.conf
echo -e "... done"

echo -e "Removing previous \"DNSnum=\" entries from /etc/sysconfig/network-scripts/ifcfg-eth0 ..."
sudo sed -i '/^DNS[0-9]/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -e "... done"

echo -e "Adding DNS1=127.0.0.1 and DNS2=10.0.2.3 to eth0 interface config ..."
sudo sed -i '/DEVICE=eth0/a DNS1=127.0.0.1\nDNS2=10.0.2.3' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -e "... done"

echo -e "Restarting network service ..."
sudo service network restart

echo -e "Restarting dnsmasq service ..."
sudo service dnsmasq restart

echo -e "Test pings (if anything times out you have an issue"
ping -c 1 localhost
ping -c 1 test.localhost
ping -c 1 google.com

echo -e "Done..."
echo -e "Thanks for playing \"cut paste 'n go\""
