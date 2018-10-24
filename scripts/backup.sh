#!/bin/bash

dia=`date +%d`
mes=`date +%m`
ano=`date +%Y`
data=$ano$mes$dia
hostname=`hostname`
tar="tar cvjf"
caminho_full="/var/squid/listas /var/squid/log /var/www/htdocs/admin /var/www/htdocs/erro /usr/local/squid /usr/local/squidGuard /etc/apache/httpd.conf /root/scripts /etc/dhcpd.conf /etc/logrotate.d/s* /etc/hosts /etc/sudoers /etc/syslog.conf /etc/rc.d/rc.local"
if [ -d /var/squid/log/squidGuard/$ano/$mes/$dia ];then
	caminho_parcial="/var/squid/log/squidGuard/$ano/$mes/$dia"
fi
caminho_parcial="$caminho_parcial /var/squid/listas /var/www/htdocs/admin/*.php /var/www/htdocs/admin/*.jpg /var/www/htdocs/admin/proxy/*.php /var/www/htdocs/admin/proxy/restart /var/www/htdocs/admin/usuarios /var/www/htdocs/erro /usr/local/squidGuard/bin/squidGuard.conf /usr/local/squid/etc /etc/apache/httpd.conf /etc/dhcpd.conf /etc/logrotate.d/s* /etc/hosts /etc/sudoers /etc/syslog.conf /etc/rc.d/rc.local"
dest="solutionlinux@gmail.com"
dir_backup="/var/tmp/backup/$ano/$mes"
arquivo_backup_full="$dir_backup/backup_full-$hostname-$data.tar.bz2"    
arquivo_backup="$dir_backup/backup-$hostname-$data.tar.bz2"    
if [ ! -d $dir_backup ];then mkdir -p $dir_backup;fi

$tar $arquivo_backup_full $caminho_full
$tar $arquivo_backup $caminho_parcial

echo "Backup Diario $hostname" | mail -s"Backup Diario $hostname" -a $arquivo_backup $dest
