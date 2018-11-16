#! /bin/bash

#适用CentOS7_Minimal

yum install bridge-utils net-tools -y
yum remove firewalld-filesystem NetworkManager-libnm -y   #若为GUI的发行版，卸载NetworkManager-libnm会导致GUI损坏
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

for i in `seq 0`;do
echo -e "DEVICE=eth${i}\nTYPE=Ethernet\nONBOOT=yes\nBRIDGE=br0" > /etc/sysconfig/network-scripts/ifcfg-eth${i}
done

echo -e "DEVICE=br0\nTYPE=Bridge\nONBOOT=yes\nBOOTPROTO=static\nIPADDR=192.168.1.31\nNETMASK=255.255.255.0\nGATEWAY=192.168.1.1" > /etc/sysconfig/network-scripts/ifcfg-br0
systemctl restart network
