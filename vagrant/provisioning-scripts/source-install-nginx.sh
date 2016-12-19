#!/bin/sh

# Simple script to install nginx mainline (lightweight webserver) and enable
#
# This script was designed to install nginx mainline on my CentOS Vagrant box.
# @see https://github.com/JohnsonMikeJ/devel-enviro/tree/master/vagrant/centos-6.8-min-x86_64
#
# @link https://github.com/JohnsonMikeJ/devel-enviro/tree/master/vagrant/provisioning-scripts/install-nginx.sh
#
# Author: Mike Johnson <mike.johnson@highimpacttech.com>
#
# Date: 2016-12-14
#

# Exit on any error
set -e

echo -e "Updating Yum ..."
sudo yum update

echo -e "Installing required libraries and tools..."
sudo yum -y install unzip gcc-c++ zlib-devel pcre-devel openssl-devel autoconf automake libtool libxml2-devel libxslt-devel 'perl(ExtUtils::Embed)'

echo -e "Creating working directory..."
mkdir -p ~/local/src
cd ~/local/src
echo -e "... done"

echo -e "Downloading and installing libunwind - required for Google Performance tools library..."
# Required for Google performance tools
wget http://download.savannah.gnu.org/releases/libunwind/libunwind-1.1.tar.gz
tar zxf libunwind-1.1.tar.gz
cd libunwind-1.1
./configure --libdir=/lib64/
make
sudo make install
cd ~/local/src

echo -e "Downloading and installing Google Performance tools library..."
wget https://github.com/gperftools/gperftools/archive/master.zip -O gperftools-master.zip
unzip gperftools-master.zip
cd gperftools-master
./autogen.sh
./configure --libdir=/lib64/
make
sudo make install
cd ~/local/src

echo -e "Downloading and installing nginx mainline..."
echo -e "Yes, running as root. Its a local only dev box - security should not be an issue :/"
wget http://nginx.org/download/nginx-1.11.7.tar.gz
tar zxf nginx-1.11.7.tar.gz
cd nginx-1.11.7
#./configure --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-stream --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=root --group=root --with-ipv6 --with-debug --with-google_perftools_module
#./configure --build=Beta-0.0.1 --user=root --group=root --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid  --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-threads --with-http_ssl_module --with-http_v2_module --with-http_xslt_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-pcre --with-zlib --with-openssl --with-debug
./configure --build=Beta_0.0.1 --user=root --group=root --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid  --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-threads --with-http_ssl_module --with-http_v2_module --with-http_xslt_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-stream --with-stream_ssl_module --with-google_perftools_module --with-pcre --with-zlib=/usr/include/ --with-openssl=/usr/include/openssl/ --with-debug
make
sudo make install
cd ~/local/src

echo -e "Downloading nginx init script..."
sudo curl -o /etc/init.d/nginx https://raw.githubusercontent.com/JohnsonMikeJ/devel-enviro/master/nginx/etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx
echo -e "... done"

echo -e "Running nginx config test script..."
sudo /etc/init.d/nginx configtest

echo -e "Starting nginx..."
sudo service nginx start

echo -e "Enabling chkconfig for nginx..."
sudo chkconfig nginx on

echo -e "Curl test (if you don't get raw html welcome page, you have an issue)"
curl -I 127.0.0.1

echo -e "Done..."
echo -e "Thanks for playing \"cut paste 'n go\""
