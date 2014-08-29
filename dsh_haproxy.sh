#!/bin/bash
# Author bob
# Since 2014-08-29
# Version $Id$

# 判断用户有没有传必要的参数，如果没有的话就报出使用方法
if [[ $# -lt 2 ]];then
  echo "USAGE: ${0##*/} group [group ...] \"command\""
  exit 1
fi

# 通过参数得到用户需要操作的组和需要操作的命令
COUNT=0
let LAST_POS=$#-1
for i in "$@"
do
  if [ $COUNT -eq $LAST_POS ]
  then
    COMMAND="$i"
  else
    DSH_GROUPS[$COUNT]=$i
  fi
  let COUNT=$COUNT+1
done

# 指定haproxy的配置文件
HA_CONFIG="/etc/haproxy.cfg"
# 临时组名称
TMP_GROUP="${0##*/}.`date +%Y%m%d%k%M%S`"
# 临时组文件路径
TMP_FILE="/var/run/$TMP_GROUP"

# 根据用户传入的组，从Haproxy配置文件中得到服务器列表IP，并写入到临时组文件里面去
function getHAServerByGroup(){
  SERVERS="`sed -n "/^backend $1/,/backend/p" $HA_CONFIG | grep -v 'disabled'|  grep '^\s*server' | awk '{print $3}' | awk -F: '{print $1}'`"
  echo $1
  for SERVER in $SERVERS
  do
    echo $SERVER >> $TMP_FILE
  done
}

for DSH_GROUP in "${DSH_GROUPS[@]}"
do
  getHAServerByGroup $DSH_GROUP
done

# 有时候一台服务器可能会出现在多个组里面，所以我们需要用sort和uniq来去重。
sort $TMP_FILE | uniq > /etc/dsh/group/$TMP_GROUP
rm $TMP_FILE 
# 加 -o 选项目的是有时候第一次连接到这台机器不用手动输入 yes 。只要做好了免密码登录就ok
dsh -o "-o StrictHostKeyChecking=no" -c -M -g $TMP_GROUP "$COMMAND"
rm /etc/dsh/group/$TMP_GROUP
