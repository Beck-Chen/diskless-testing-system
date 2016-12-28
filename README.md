 # diskless-testing-system
  A PXE boot server for functional test 
  
  
  
 statement of usage:
 1. All the scripts are based on CentOS6 x86_64, please refer to <PXE diskless system creation.txt> to understand the detail inforamtion. Make sure yum respository is correctly configured before running these scripts. Please refer to chapter 4.7 in <PXE diskless system creation.txt> to configure yum.
 
 2. mk_srv.sh: This script is used in server side to automatically configure a PXE server. ethernet card and dhcp,tftp,nfs services will abe configured after running this script. PXE menu file "default" will also be created in /pxeserver/tftp/pxelinux.cfg directory. Rebooting is required after the process. Please make sure files of ifconfig-eth0,dhcp.conf,pxe_menu_adv.conf and tftp are located in the same directory with this script.
     command     sh mk_srv.sh
 
 3. mk_client.sh: This script is used in client side to automatically created an initrd file and a bootable nfs directory, all the files will be compressed in the tar.gz file which is named based on the machine name you are required to input.
     command     sh mk_client.sh
         
4. Uncompress the tar.gz file which was generated in step3 to the "/" directory in server side.
     command     cd /
                 tar zxvf machinename.tar.gz
     
5. Run pxe_menu_config.sh in server side and it will modify pxe menu entry, the exactly same machine name you input in step3 will be required to input again in this step.
     command    sh pxe_menu_config.sh
     
6. Configure the boot sequence in any of same model client and enjoy the PXE diskless system.

Beck Chen
2016/12/28


使用说明:
 
1. 所有脚本基于CentOS6 X86_64系统,其他系统需要修改脚本.请阅读<PXE diskless system creation.txt>文档了解详情. 运行前需确保yum源正确配置,请参考<PXE diskless system creation.txt> 4.7节.

2. mk_srv.sh:制作PXE server, 在服务器端运行,功能为自动配置网卡,安装配置并开启dhcp,tftp,nfs,生成/pxeserver/tftp/pxelinux.cfg/default文件. 指令运行成功后需重启服务器.使用该脚本时必须保证ifcfg-eth0,dhcpd.conf,pxe_menu_adv.conf,tftp这4个文件与脚本在相同的路径下.
    运行指令  sh mk_srv.sh

3. mk_client.sh:制作客户端PXE镜像,在客户端已安装的本地操作系统内运行,生成镜像目录并打包压缩为 机器名.tar.gz

    运行指令  sh mk_client.sh
    需输入合法的机器名以创建路径和压缩包名称

4. 将第3步生成的打包文件拷贝到服务器端,并在根目录下使用 tar -zxvf 机器名.tar.gz 解压. 

5. 在服务器端运行pxe_menu_config.sh脚本,完成对/pxeserver/tftp/pxelinux.cfg/default文件的修改，生成对应的pxe menu entry.
   	进入脚本所在路径后运行指令 sh pxe_menu_config.sh

6. 将同型号客户端服务器设定为从网络启动并连接到服务器即可实现PXE无盘启动.


Beck Chen
2016/12/26
