#!/bin/bash
#Post config install script for RedHat 6 and 7 boxes
#Luke Wood
#University of Wyoming
#Information Technology TSSS
#4/28/2016

#Check for install envinorment ie. is root.
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo "Running post install configuration for this linux server"
echo "Detecting version"
if [$(cat /etc/redhat-release | awk '{print $7}' | cut -c 1 ) = "7"]; then
  echo "It looks like this machine is running Red Hat 7"
  # Attaching to RedHat subscription
  echo "Attempting to attach to RedHat subscription please enter RedHat account:"
  read account
  echo "Please enter RedHat account password:"
  read -s password

  subscription-manager register --username "$username" --password "$password" --auto-attach

  # Checking to see if Chrony or NTP is being used.  Depending on which time
  # management system is being used will edit the apporiate file.
  # Looks for either ntpd.conf or chrony.conf
  if [ -e /etc/ntpd.conf ]; then
    sed -i '/server 0.rhel.pool.ntp.org iburst/d' /etc/ntpd.conf
    for i in {1..4}
    do
      sed -i "s/server $i.rhel.pool.ntp.org iburst/server time$i.uwyo.edu iburst" /etc/ntpd.conf
    done
  elif [ -e /etc/chrony.conf ]; then
    sed -i '/server 0.rhel.pool.net.org iburst/d' /etc/chrony.conf
    for i in {1..4}
    do
      sed -i "s/server $i.rhel.pool.ntp.org iburst/server time$i.uwyo.edu iburst" /etc/chrony.conf
    done
  else
    echo "You don't seem to have any network time server installed this may effect kerberos operation"
    echo "Would like to install one? 1)ntpd 2)chrony n)no "
    read time_answer
    case "$time_answer" in
      1)
      yum -y install ntpd
      sed '/server 0.rhel.pool.net.org iburst/d' /etc/ntpd.conf
      for i in {1..4}
      do
        sed -i "s/server $i.rhel.pool.ntp.org iburst/server time$i.uwyo.edu iburst" /etc/ntpd.conf
      done
      ntpdate time2.uwyo.edu
      systemctl enable ntpd
      systemctl start ntpd
      ;;
      2)
      yum -y install chrony
      sed '/server 0.rhel.pool.net.org iburst/d' /etc/chrony.conf
      for i in {1..4}
      do
        sed -i "s/server $i.rhel.pool.ntp.org iburst/server time$i.uwyo.edu iburst" /etc/chrony.conf
      done
      systemctl enable chrony
      systemctl start chrony
      ;;
      n|N)
      echo "Not having a time server may lead to bad things down the road"
      echo "You have been warned!"
      ;;
    esac
  fi

  # Runs updates at this point and installs basic pacakges
  yum -y update
  yum -y install bind-utils open-vm-tools pam_krb5 bash-completion net-snmp\
  net-snm-libs net-snmp-utils vim-enhanced setroubleshoot-server\
  policycoreutils-python logwatch tree

  #Setup AD Auth
  authconfig --enablelocauthorize --useshadow --enablekrb5 --krb5kdc=windows.uwyo.edu:88\
  --krb5adminserver=windows.uwyo.edu:749 --krb5realm=WINDOWS.UWYO.EDU --update

  #Adding Deptsys SA accounts
  for sa_account in {jefflang,atenna1,gschroye,rkoller,lwood16,ecbfoger}-sa
  do
    useradd -G wheel $sa_account
  done

  #Configuring Postfix
  sed -i "318imyhostname=$HOSTNAME" /etc/postfix/main.cf
  #Logic to determin if mail940.uwyo.edu is needed instead
  if [ $(ip addr show | grep 'inet 10.84' | awk '{print $2}' | cut -b 7-8) = "40"];
  then
    sed -i '319irelayhost=mail940.uwyo.edu' /ete/postfix/main.cf
  else
    sed -i '319irelayhost=mail.uwyo.edu' /etc/postfix/main.cf
  fi
  systemctl reload postfix
  echo "deptsys-it@uwyo.edu" >> /root/.forward

  # Configuring SSH
  sed -i '47iPermitRootlogin no' /etc/ssh/sshd_config
  sed -i "48iAllowUsers jefflang-sa atenna1-sa gschroye-sa rkoller-sa lwood16-sa ecbfoger-sa" /etc/ssh/sshd_config
  sed -i '49iLoginGraceTime 1m' /etc/ssh/sshd_config
  sed -i '50iClientAliveInterval 1800' /etc/ssh/sshd_config
  sed -i '51iClientAliveCountMax 2' /etc/ssh/sshd_config

  # Firewall configuration
  echo "Time to configure the firewall in Red Hat 7 you have a choice firewalld (default)"
  echo "or IPCHAINS"
  echo "Please choose to continue 1)Firewalld or 2)IPCHAINS:"
  read firewall

case "$firewall" in
  1)
  #Firewalld is already installed and only needs to be configured
  #Rich Rules
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.84.76.0/24" service name="ssh" log prefix="SSH DBO" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.84.45.0/24" service name="ssh" log prefix="SSH 945" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.100.100.0/24" service name="ssh" log prefix="SSH lib" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.100.101.0/24" service name="ssh" log prefix="SSH lib" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.100.102.0/24" service name="ssh" log prefix="SSH lib" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.84.64.33" port port="161" protocol="udp" log prefix="SNMPD NMS" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.84.40.94" port port="161" protocol="udp" log prefix="SNMPD NMS" level="info" accept'
  firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.84.45.0/24" port port="161" protocol="udp" log prefix="SNMPD 945" level="info" accept'

  #Removing the default services
  firewall-cmd --permanent --remove-service=dhcpv6-client
  firewall-cmd --permanent --remove-service=ssh

  #Direct Rule example
  firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -s 10.84.45.0/24 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
  echo "Please review rules and adjust as nessary"
  ;;
  2)
  #Enabling IPCHAINS requires disabling firewalld
  systemctl mask firewalld
  systemctl stop firewalld
  yum -y install iptables-services
  systemctl enable iptables
  mv /etc/sysconfig/iptables /etc/sysconfig/iptables.bak
  echo "# IPTABLES"  > /etc/sysconfig/iptables
  echo "#The firewall will have very basic values in it from the default install.  It will basically allow everything.  This will be replaced by a " >> /etc/sysconfig/iptables
  echo "configuration that will disallow everything except what you add as allowable.  The following is a basic table that will allow web traffic and ssh" >> /etc/sysconfig/iptables
  echo "traffic." >> /etc/sysconfig/iptables
  echo "# RHEL 7 changes the way it assigns NICs so run ip addr to get the interface name, most likely NOT eth0!" >> /etc/sysconfig/iptables
  echo "# Firewall configuration written by system-config-firewall" >> /etc/sysconfig/iptables
  echo "# Manual customization of this file is not recommended." >> /etc/sysconfig/iptables
  echo "*filter" >> /etc/sysconfig/iptables
  echo ":INPUT DROP [0:0]" >> /etc/sysconfig/iptables
  echo ":FORWARD ACCECPT [0:0]" >> /etc/sysconfig/iptables
  echo ":OUTPUT ACCEPT [342:38553]" >> /etc/sysconfig/iptables
  echo '-A INPUT -p tcp -m tcp --dport 80 -m string --string "GET /w00tw00t" --algo bm --to 70 -j DROP' >> /etc/sysconfig/iptables
  echo '-A INPUT -p tcp -m tcp --dport 443 -m string --string "GET /w00tw00t" --algo bm --to 70 -j DROP' >> /etc/sysconfig/iptables
  echo '-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -p icmp -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -i lo -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.43.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.44.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.45.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.60.103/32 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.100.100.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.100.101.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.100.102.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -i eth0 -p tcp -m tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -i eth0 -p tcp -m tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -j REJECT --reject-with icmp-host-prohibited' >> /etc/sysconfig/iptables
  echo '-A FORWARD -j REJECT --reject-with icmp-host-prohibited' >> /etc/sysconfig/iptables
  echo 'COMMIT' >> /etc/sysconfig/iptables
  systemctl start iptables
  ;;
esac
echo "Script is done at this point.  Happy admining!"
exit 0

elif [ $(cat /etc/redhat-release | awk '{print $7}' | cut -c 1 ) = "6" ];
  then
  echo "It looks like this machine is running Red Hat 6"
  echo "Attempting to attach to RedHat subscription please enter RedHat account:"
  read account
  echo "Please enter RedHat account password:"
  read -s password

  subscription-manager register --username "$username" --password "$password" --auto-attach

  # need to edit /etc/sudoers and add %wheel ALL=(ALL)    ALL
  echo "%wheel ALL=(ALL) ALL" | (EDITOR="tee -a" visudo)

  #Setting up time server
  yum -y install ntpd
  sed '/server 0.rhel.pool.net.org iburst/d' /etc/ntpd.conf
  for i in {1..4}
  do
    sed -i "s/server $i.rhel.pool.ntp.org iburst/server time$i.uwyo.edu iburst" /etc/ntpd.conf
  done
  ntpdate time2.uwyo.edu
  chkconfig ntpd on
  service ntpd start

  # Runs updates at this point and installs basic pacakges
  yum -y update
  yum -y install bind-utils open-vm-tools pam_krb5 bash-completion net-snmp\
  net-snm-libs net-snmp-utils vim-enhanced setroubleshoot-server\
  policycoreutils-python logwatch tree

  #Setup AD Auth
  authconfig --enablelocauthorize --useshadow --enablekrb5 --krb5kdc=windows.uwyo.edu:88\
  --krb5adminserver=windows.uwyo.edu:749 --krb5realm=WINDOWS.UWYO.EDU --update

  #Adding Deptsys SA accounts
  for sa_account in {jefflang,atenna1,gschroye,rkoller,lwood16,ecbfoger}-sa
  do
    useradd -G wheel $sa_account
  done

  # Configuring SSH
  sed -i '47iPermitRootlogin no' /etc/ssh/sshd_config
  sed -i "48iAllowUsers jefflang-sa atenna1-sa gschroye-sa rkoller-sa lwood16-sa ecbfoger-sa" /etc/ssh/sshd_config
  sed -i '49iLoginGraceTime 1m' /etc/ssh/sshd_config
  sed -i '50iClientAliveInterval 1800' /etc/ssh/sshd_config
  sed -i '51iClientAliveCountMax 2' /etc/ssh/sshd_config

  #Configuring Postfix
  sed -i "318imyhostname=$HOSTNAME" /etc/postfix/main.cf
  #Logic to determin if mail940.uwyo.edu is needed instead
  if [ $(ip addr show | grep 'inet 10.84' | awk '{print $2}' | cut -b 7-8) = "40"];
  then
    sed -i '319irelayhost=mail940.uwyo.edu' /ete/postfix/main.cf
  else
    sed -i '319irelayhost=mail.uwyo.edu' /etc/postfix/main.cf
  fi
  service postfix reload
  echo "deptsys-it@uwyo.edu" >> /root/.forward

  #Configuring Ipchains
  mv /etc/sysconfig/iptables /etc/sysconfig/iptables.bak
  echo "# IPTABLES"  > /etc/sysconfig/iptables
  echo "#The firewall will have very basic values in it from the default install.  It will basically allow everything.  This will be replaced by a " >> /etc/sysconfig/iptables
  echo "configuration that will disallow everything except what you add as allowable.  The following is a basic table that will allow web traffic and ssh" >> /etc/sysconfig/iptables
  echo "traffic." >> /etc/sysconfig/iptables
  echo "# RHEL 7 changes the way it assigns NICs so run ip addr to get the interface name, most likely NOT eth0!" >> /etc/sysconfig/iptables
  echo "# Firewall configuration written by system-config-firewall" >> /etc/sysconfig/iptables
  echo "# Manual customization of this file is not recommended." >> /etc/sysconfig/iptables
  echo "*filter" >> /etc/sysconfig/iptables
  echo ":INPUT DROP [0:0]" >> /etc/sysconfig/iptables
  echo ":FORWARD ACCECPT [0:0]" >> /etc/sysconfig/iptables
  echo ":OUTPUT ACCEPT [342:38553]" >> /etc/sysconfig/iptables
  echo '-A INPUT -p tcp -m tcp --dport 80 -m string --string "GET /w00tw00t" --algo bm --to 70 -j DROP' >> /etc/sysconfig/iptables
  echo '-A INPUT -p tcp -m tcp --dport 443 -m string --string "GET /w00tw00t" --algo bm --to 70 -j DROP' >> /etc/sysconfig/iptables
  echo '-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -p icmp -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -i lo -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.43.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.44.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.45.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.84.60.103/32 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.100.100.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.100.101.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -s 10.100.102.0/24 -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -i eth0 -p tcp -m tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -i eth0 -p tcp -m tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT' >> /etc/sysconfig/iptables
  echo '-A INPUT -j REJECT --reject-with icmp-host-prohibited' >> /etc/sysconfig/iptables
  echo '-A FORWARD -j REJECT --reject-with icmp-host-prohibited' >> /etc/sysconfig/iptables
  echo 'COMMIT' >> /etc/sysconfig/iptables
  service iptables restart
  echo "Script is done at this point. Happy admining!"
  exit 0

else
  echo "Can't tell which distro this is system is running"
  echo "This script will only run on Red Hat 6 & 7 systems."
  echo "Either something is wrong with the install or this is not Red Hat"
  echo "ABORTING"
  exit 1
fi
