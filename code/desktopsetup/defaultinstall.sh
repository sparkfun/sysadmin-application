#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get update && apt-get upgrade -y && apt-get install wireshark tshark nmap vlan bridge-utils ifenslave ethtool mtr vim terminator gparted python-pip build-essential python-dev bridge-utils meld keepassx dia filezilla htop -y

pip install rope spyder ipython pyflakes pep8 addict pymongo colorama pexpect scapy pyp

echo "8021q" >> /etc/modules
echo "bonding" >> /etc/modules

groupadd wireshark
chgrp wireshark /usr/bin/dumpcap
chmod 750 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
echo "Pleas add correct users to wireshark group using'usermod -a -G wireshark user'"
ldconfig

exit 0
#only for compiling wireshark from source 
#apt-get install autoconf libgtk2.0-dev libglib2.0-dev libgeoip-dev libpcre3-dev libpcap0.8-dev libtool byacc flex subversion libcap2-bin && ldconfig
