#!/bin/bash

dia=`date +%d`
mes=`date +%m`
ano=`date +%Y`
#data=`date +%Y%m%d`
data=$ano$mes$dia
log=/var/squid/log/access.log.1
#antigo 20060731 ##calamaris="/usr/local/bin/calamaris -a -u -F html"
calamaris="/usr/local/bin/calamaris -d -1 -u -R -1 -s -D 2 -a -r -1 -c -N -1 -U K -O -F html"
dir=/var/www/htdocs/admin/proxy/logs/
relatorio=$dir$ano/$mes/diario$data.html
link=/var/www/htdocs/admin/proxy/logs/diario.html
##script de geracao do relatorio diario do squid atraves do calamaris
if [ ! -d $dir$ano/$mes ]; then
	mkdir -p $dir$ano/$mes
fi
cat $log | grep -v rogerio | grep -v nazio | grep -v mario | grep -v wesley | $calamaris >$relatorio
rm -fr $link
ln -s $relatorio $link
