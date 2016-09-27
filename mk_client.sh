#!/bin/bash

#This script is based on CentOS 6.X X86_64. The function is to create PXE boot root file system, initrd image, 
#copy kernel file and compress the image folder into a single .tar.gz file in a newly installed OS.


# Author: Beck Chen  
# Email:  chen.beck@hotmail.com
# History:2016/9/24 FirstRelease


#Checking whether dracut and dracut-network are both installed or not.

declare -i sw_chk=`rpm -qa | grep -c 'dracut-[n[:digit:]]'`
if [ $sw_chk -lt 2 ]; then
	echo -e "\e[1;41mdracut and|or dracut-network were not installed, please install and re-run this script.\e[0m"
	
else 
	#create directory base on model name to save root nfs system	
	echo -e "\e[1;44mPlease key in the Unit or MLB model name to create a directory(EX:K900G3.)\
	PS: Must be unique from any known linux system directory name and must be a legal directory name!!!\e[0m"
	read -p "Model Name:" modelname
	pxe_dir=/pxeserver
	model_dir=$pxe_dir/models/$modelname
	tftp_dir=$pxe_dir/tftpboot
	mkdir  -p $pxe_dir $model_dir $tftp_dir
	
	cd /
	#copy current root file system to the directory you just created
	rsync -av --exclude='/proc' --exclude='/sys' --exclude='/tmp' \
--exclude='/var/tmp' --exclude='/etc/mtab' --exclude="$pxe_dir" /* $model_dir
	mkdir -p $model_dir/proc $model_dir/sys $model_dir/tmp $model_dir/var/tmp

	#remove networking configuration files
	rm -f $model_dir/etc/sysconfig/network-script/ifcfg-e*

	#modify etc/fstab, use "" instead of '' in sed command due to varible is used in the command,
	#Change local mount points into nfs address. May need modification if the HDD partition was customerized.
	#sed -i "s/^.*root.*/192\.168\.1\.5:$model_dir\t\/\tnfs\tdefaults\t0\ 0/g" $model_dir/etc/fstab
	#sed -i "s/^.*\/boot.*//g" $model_dir/etc/fstab
    mv $model_dir/etc/fstab $model_dir/etc/fstab.bak
	grep -v 'ext' $model_dir/etc/fstab.bak | grep -v '#' \
	| sed "1i 192\.168\.1\.5:$model_dir\t\/\tnfs\tdefaults\t0\ 0"
	>$model_dir/etc/fstab
	
	#create initrd image and cp kernel file
	echo -e "\e[1;44mCreating initrd image is in progress and this may take a few minutes...     \e[0m"
	dracut initrd-`uname -r`.img `uname -r`
	mv initrd-`uname -r`.img $tftp_dir/initrd-$modelname.img
	chmod 644 $tftp_dir/initrd-$modelname.img
	cp /boot/vmlinuz-`uname -r` $tftp_dir/vmlinuz-$modelname

	#compress the directory
	tar -zcvf $modelname.tar.gz $pxe_dir

	echo -e "\e[1;42mAll the nfs root files were successfully compressed in $modelname.tar.gz    \e[0m"
	echo -e "\e[1;42mPlease copy and extract it to / of PXE server by tar -zxvf $modelname.tar.gz\e[0m"
	echo -e "\e[1;42mEdit PXE menu in $tftp_dir/pxelinux.cfg/default                            \e[0m"
fi
