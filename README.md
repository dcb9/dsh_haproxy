dsh_haproxy
===========

通过dsh来批量维护haproxy组下的服务器

####依赖
* /etc/haproxy.cfg  # haproxy的配置文件必须放到这
* dsh 批量操作多台服务器的小工具
* bash shell

####下载
* 创建本地源包存放路径 
`# mkdir -p /usr/local/src 2>/dev/null ; cd /usr/local/src `
* 通过git
`# git clone https://github.com/bobchengbin/dsh_haproxy.git`
* 通过wget下载源码包的方式

`# wget https://codeload.github.com/bobchengbin/dsh_haproxy/tar.gz/v0.2 -O dsh_haproxy-0.2.tar.gz`

`# tar -zxvf dsh_haproxy-0.2.tar.gz `

####安装
```
# cd /usr/local/src/dsh_haproxy-0.2
# cp dsh_haproxy.sh /usr/local/bin
# chmod +x /usr/local/bin/dsh_haproxy.sh
# cp dsh_haproxy.sh-complete /usr/local/bin/
# echo "source /usr/local/bin/dsh_haproxy.sh-complete" >> /etc/bash/bashrc
# source /usr/local/bin/dsh_haproxy.sh-complete
```

####使用
haproxy的配置文件放到 /etc/haproxy.cfg
```
# dsh_haproxy.sh <tab><tab>   这样就能列出所有haproxy的backend组名  git !
# dsh_haproxy.sh 组名 [组名 ... ] "操作的命令"
```
fix a bug that 
