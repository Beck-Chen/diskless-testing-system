 # diskless-testing-system
  A PXE boot server for functional test 
 +
 +
 +
 +使用说明:
 +
 +
 +1. 所有脚本基于CentOS6 X86_64系统,其他系统需要修改脚本.请阅读<PXE无盘制作.txt>文档了解详情. 运行前需确保yum源正确配置,请参考<PXE无盘制作.txt> 4.7节.
 +
 +
 +2. mk_srv.sh:制作PXE server, 在服务器端运行,功能为自动配置网卡,安装配置并开启dhcp,tftp,nfs,生成/pxeserver/tftp/pxelinux.cfg/default文件. 指令运行成功后需重启服务器.
 +   使用该脚本时必须保证ifcfg-eth0,dhcpd.conf,pxe_menu.conf,tftp这4个文件与脚本在相同的路径下.
 +
 +    运行指令  sh mk_srv.sh
 + 
 +
 +3. mk_client.sh:制作客户端PXE镜像,在客户端已安装的本地操作系统内运行,生成镜像目录并打包压缩为 机器名.tar.gz
 +    
 +   运行指令  sh mk_client.sh
 +   
 +   需输入合法的机器名以创建路径和压缩包名称
 +
 +
 +4. 将第3步生成的打包文件拷贝到服务器端,并在根目录下使用 tar -zxvf 机器名.tar.gz 解压. 
 +
 +5. 在服务器端修改第2步生成的/pxeserver/tftp/pxelinux.cfg/default文件.将文件中的xxx替换为第3步输入的机器名(区分大小写).
 +
 +6. 将同型号客户端服务器设定为从网络启动并连接到服务器即可实现PXE无盘启动.
 +
 +7. PXE高级选单制作请参考<PXE无盘制作.txt> 4.2节.
 +
 +
 +
 +Beck Chen
 +2016/9/26
