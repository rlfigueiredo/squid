#!/bin/bash

dia=`date +%d`
mes=`date +%m`
ano=`date +%Y`
data=$ano$mes$dia
if [ ! -d /root/logs/$ano/$mes ]; then mkdir -p /root/logs/$ano/$mes;fi
arquivo_log=/root/logs/$ano/$mes/stat_iptables_$data.log
dest="solutionlinux@gmail.com"

iptables -L -n -v --line-numbers >>$arquivo_log
iptables -t nat -L -n -v --line-numbers >>$arquivo_log
echo -e "`df -h`\n\n`/usr/bin/w`\n\n`/usr/bin/last`" | mail -s"Status Iptables - $data - `hostname`" -a $arquivo_log $dest
/etc/rc.d/rc.firewall
