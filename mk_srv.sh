#!/bin/bash

#This script is based on CentOS 6.X X86_64. The function is to setup a PXE server in a newly installed OS;
#dhcpd,tftpd,nfs,syslinux will be automatically configured after running this script
#PXE configuration file will also be created


# Author: Beck Chen  
# Email:  chen.beck@hotmail.com
# History:2016/9/24 FirstRelease
#         2016/12/26 Modify PXE menu configuration to advanced version


#directories of key files
cfg_eth0=/etc/sysconfig/network-scripts/ifcfg-eth0
cfg_dhcp=/etc/dhcp/dhcpd.conf
cfg_tftp=/etc/xinetd.d/tftp
cfg_selinux=/etc/selinux/config
cfg_nfs=/etc/exports

#pkg_dir is the directory in which this script is located.
#Usage: find and copy default cfg files in this directory, and load 
#them to modify corresponding configuration files. 
pkg_dir=$(dirname $(readlink -f $0))
tftp_dir=/pxeserver/tftpboot
img_dir=/pxeserver/models
pxe_menu_dir=$tftp_dir/pxelinux.cfg



#Configure static ip 192.168.1.5 for eth0
#sed -i 's/ONBOOT.*/ONBOOT=yes/g' $cfg_eth0
#sed -i 's/BOOTPROTO.*/BOOTPROTO=none/g' $cfg_eth0
cat $pkg_dir/ifcfg-eth0 > $cfg_eth0


#Installing and configure dhcp
yum install -y dhcp 

if [ $? -ne 0 ]; then
	echo -e "\e[1;41mYUM is not configured correctly. Please check it!!!\e[0m"
	exit 1
fi

cat $pkg_dir/dhcpd.conf > $cfg_dhcp


#Install and configure tftp
yum install -y tftp-server
#sed -i "s/\/var/\lib.*tftpboot/$tftp_dir/g" $cfg_tftp
#sed -i 's/disble.*/disable\t\t\t=\ no/g' $cfg_tftp
mkdir -p $tftp_dir
cat $pkg_dir/tftp > $cfg_tftp


#Install and configure nfs
yum install -y nfs-utils rpcbind
mkdir -p $img_dir
echo "$img_dir	192.168.1.0/24(rw,async,no_root_squash)" > $cfg_nfs


#Install syslinux
yum install -y syslinux
cp /usr/share/syslinux/pxelinux.0 $tftp_dir


#Configure PXE menu file, may need to modify after client image is created.
mkdir -p $pxe_menu_dir
cp -f $pkg_dir/vesamenu.c32 $pxe_menu_dir
cp -f $pkg_dir/splash.jpg $pxe_menu_dir
cat $pkg_dir/pxe_menu_adv.conf > $pxe_menu_dir/default


#Configure Selinux 
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' $cfg_selinux


#Turn on all services. Exit and warn if any errors reported.

ifup eth0
ifconfig eth0 | grep "192.168.1.5"
if [ $? -ne 0 ]; then
	echo -e "\e[1;41mNIC0 is not configured correctly. Please check it!!!\e[0m"
	exit 1
fi

service dhcpd restart
if [ $? -ne 0 ]; then
	echo -e "\e[1;41mDHCP is not configured correctly. Please check it!!!\e[0m"
	exit 1
fi
chkconfig dhcpd on

service xinetd restart
if [ $? -ne 0 ]; then
	echo -e "\e[1;41mTFTP is not configured correctly. Please check it!!!\e[0m"
	exit 1
fi
chkconfig xinetd on

service iptables stop
if [ $? -ne 0 ]; then
	echo -e "\e[1;41mFirewall is not closed correctly. Please check it!!!\e[0m"
	exit 1
fi
chkconfig iptables off

service rpcbind restart
if [ $? -ne 0 ]; then
	echo -e "\e[1;41mrpcbind is not configured correctly. Please check it!!!\e[0m"
	exit 1
fi
chkconfig rpcbind on

service nfs restart
if [ $? -ne 0 ]; then
	echo -e "\e[1;41mNFS is not configured correctly. Please check it!!!\e[0m"
	exit 1
fi
chkconfig nfs on
exportfs

echo -e "\e[1;42mDHCP,TFTP and NFS services are all configured correctly.\e[0m"
echo -e "\e[1;42mPlease extract client image to pxeserver directory and modify modelname in $pxe_menu_dir/default entries.\e[0m"
echo ""
echo -e "\e[1;42mPlease reboot server and check the status of all these services to make sure they are configured properly.\e[0m"


 
