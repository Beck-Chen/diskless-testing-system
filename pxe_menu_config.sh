
#!/bin/bash

#This script is based on CentOS 6.X X86_64. The function is to create pxe menu entry for new created client image.
#pxe_menu_entry will be added to the tail of default pxe menu file and modification will be needed after this.


# Author: Beck Chen  
# Email:  chen.beck@hotmail.com
# History:2016/12/26 FirstRelease



#pkg_dir is the directory in which this script is located.
#Usage: find and copy default cfg files in this directory, and load 
#them to modify corresponding configuration files. 
pkg_dir=$(dirname $(readlink -f $0))
tftp_dir=/pxeserver/tftpboot
img_dir=/pxeserver/models
pxe_menu_dir=$tftp_dir/pxelinux.cfg
cat $pkg_dir/pxe_menu_entry >> $pxe_menu_dir/default


echo -e "\e[1;44mPlease input the client modelname you just created in order to configure the menu file. Must be the exactly same with the one in the tar file!\e[0m"
read -p "Model Name:" modelname

sed -i "s/xxx/$modelname/g" $pxe_menu_dir/default