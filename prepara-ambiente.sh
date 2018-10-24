#!/bin/bash


funcconfsquid () {
	echo "##inicio funcconfsquid##"

	echo "## declaracao de variaveis"
	zipsquid="/home/downloads/softwares/squid/$versaosquid.tar.bz2"
	bincalamaris="/home/downloads/softwares/calamaris/$versaocalamaris/calamaris"
	configuresquid="cd $homeinstall;tar xvjf $versaosquid.tar.bz2; cd $versaosquid ; ./configure --prefix=/usr/local/$versaosquid --with-pthreads --enable-ssl --with-large-files --enable-large-cache-files --enable-underscores && make && make install"
	configuresquidauth="cd $homeinstall/$versaosquid/helpers/basic_auth/NCSA;make && make install"
	raiz="/var/squid"
	cache="$raiz/cache"
	listas="$raiz/listas/todos $raiz/listas/blacklist $raiz/listas/suporte" 
	squidconf="/usr/local/$versaosquid/etc/squid.conf"
	squidsbin="/usr/local/$versaosquid/sbin/squid"
	usuarios="$raiz/listas/.usuarios"

	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipsquid $zipsquidGuard $host:$homeinstall

	echo "## instalando squid"
	ssh $host "$configuresquid"
	ssh $host "$configuresquidauth"

	echo "##instalando calamaris"
	scp $bincalamaris $host:/usr/local/bin

	echo "## criando links simbolicos"
	ssh $host "ln -s /usr/local/$versaosquid /usr/local/squid"

	echo "## configurando squid"
	cp squid/squid.conf.padrao squid/squid.conf.$cliente
	for i in $log $cache $listas;do
		ssh $host mkdir -p $i
	done;
	for i in $listas;do
		ssh $host "touch $i/domains && touch $i/urls && touch $i/expressions"
	done;
	ssh $host "htpasswd -bc $usuarios suporte solution2030 && chown -R nobody $raiz"
	scp squid/squid.conf.$cliente $host:$squidconf
	ssh $host "$squidsbin -z"

	echo "##final funcconfsquid##"
}

funcconfsquidguard () {

	echo "##inicio funcconfsquidguard##"

	echo "## declaracao de variaveis"
	zipsquidGuard="/home/downloads/softwares/squidGuard/$versaosquidGuard.tar.gz"
	bd="/usr/local/$versaobd/BerkeleyDB"
	configuresquidGuard="cd $homeinstall; tar xvzf $versaosquidGuard.tar.gz ; cd $versaosquidGuard ; ./configure --prefix=/usr/local/$versaosquidGuard --with-db=$bd --with-db-lib=$bd/lib --with-db-inc=$bd/include && make && make install"
	raiz="/var/squid"
	log="$raiz/log/squidGuard"
	squidGuard="/usr/local/$versaosquidGuard/bin/squidGuard.conf"
	
	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipsquidGuard $host:$homeinstall

	echo "## instalando squidGuard"
	echo "ssh $host \"$configuresquidGuard\""
	ssh $host "$configuresquidGuard"
	
	echo "## criando links simbolicos squidGuard"
	ssh $host "ln -s /usr/local/$versaosquidGuard /usr/local/squidGuard"

	echo "## configurando squidGuard"
	ssh $host "touch $squidGuard && chown nobody $squidGuard"

	echo "##final funcconfsquidguard##"
}

funcconfapache () {
	echo "## inicio funcconfapache ##"

	echo "## declaracao de variaveis"
	apachehost="/etc/httpd/httpd.conf"
	apacheconfnovo="apache/conf/httpd.conf.$cliente"
	apacheconftemp="apache/conf/httpd.conf.temp"
	paginarestart="/var/www/htdocs/admin/proxy/restart/restart.php"
	paginarestartnova="apache/restart.php.nova"
	paginasquidguard="/var/www/htdocs/erro/squidGuard.php"
	paginasquidguardnova="apache/squidGuard.php.nova"
	
	
	echo "## copiando arquivos de configuracao"
	scp -r apache/htdocs/* $host:/var/www/htdocs
	ssh $host "cp $apachehost $apachehost.orig"
	scp $host:$apachehost apache/conf/

	echo "## acertando arquivos de configuracao"
	sed "s+index.html+index.html index.php+g" apache/conf/httpd.conf >$apacheconftemp
	sed "s+#Include /etc/apache/mod_php.conf+Include /etc/httpd/mod_php.conf+g" $apacheconftemp >$apacheconfnovo
	echo "<Directory \"/var/www/htdocs/admin\">
        	AuthType Basic
        	AuthName \"Administracao Squid\"
        	AuthUserFile /var/squid/listas/.usuarios
        	Require user suporte
	</Directory>" >>$apacheconfnovo

	echo "## copiando arquivos novos e alterando permissoes para o servidor"
	scp $apacheconfnovo $host:$apachehost
	ssh $host "mkdir /var/www/htdocs/.old;mv /var/www/htdocs/index* /var/www/htdocs/.old; touch /var/www/htdocs/index.html"
	ssh $host chmod 755 /etc/rc.d/rc.httpd
	ssh $host /etc/rc.d/rc.httpd restart

	echo "## acertando paginas de restart e de erro"
	scp $host:$paginarestart apache/
	sed "s+http://localhost+http://$subnet.1+g" apache/restart.php >$paginarestartnova
	scp $paginarestartnova $host:$paginarestart
	scp $host:$paginasquidguard apache/
	sed "s+squidclientesolutionlinux+$email+g" apache/squidGuard.php >$paginasquidguardnova
	scp $paginasquidguardnova $host:$paginasquidguard
	
	echo "## final funcconfapache ##"
}

funcconfsshroot () {
	echo "## inicio funcconfsshroot ##"
	home="/root"
	ssh_dir="$home/.ssh/"
	ssh_key="$home/.ssh/authorized_keys"

	ssh $host "mkdir $home $ssh_dir"
	ssh $host "echo `cat ~/.ssh/id_rsa.pub` >>$ssh_key"

	echo "## final funcconfsshroot ##"
}

funcconfusuario () {
	echo "## inicio funcconfusuario ##"
	echo "## declaracao de variaveis"
	user_passwd="admroot:x:1000:100:,,,:/home/admroot:/bin/bash"
	senha="conf_so/shadow-admroot"
	usuario="admroot.users"
	passwd="/etc/passwd"
	shadow="/etc/shadow"
	home="/home/admroot"
	ssh_dir="$home/.ssh/"
	ssh_key="$home/.ssh/authorized_keys"

	echo "## criando usuario, acertando permissoes e copiando chave ssh"
	ssh $host "echo $user_passwd >>$passwd"
	scp $senha $host:~/
	ssh $host "cat ~/shadow-admroot >>$shadow"
	ssh $host "mkdir $home $ssh_dir"
	ssh $host "echo `cat ~/.ssh/id_rsa.pub` >>$ssh_key"
	ssh $host "chown -R $usuario $home"

	echo "## final funcconfusuario ##"
}

funcconfso () {
	echo "## inicio funcconfso ##"

	echo "## declaracao de variaveis"
	logrotate_squid="/etc/logrotate.d/squid"
	logrotate_syslog="/etc/logrotate.d/syslog"
	logrotate_httpd="/etc/logrotate.d/httpd"
	rc_local="/etc/rc.d/rc.local"
	sudoers="/etc/sudoers"
	syslog="/etc/syslog.conf"
	crontab="/var/spool/cron/crontabs/root"
	hosts="/etc/hosts"
	sshd="/etc/ssh/sshd_config"
	sshd_novo="conf_so/sshd_config.novo"
	lilo="/etc/lilo.conf"
	lilo_novo="conf_so/lilo.conf.novo"
	inittab="/etc/inittab"
	inittab_novo="conf_so/inittab.novo"
	inetd="/etc/inetd.conf"
	velhos="/root/velhos"

	echo "## criando diretorio para guardar arquivos originais e copiando arquivos originais"
	ssh $host "if ! [ -d /root/velhos ]; then mkdir -p $velhos;fi"
	for i in $logrotate_squid $logrotate_syslog $logrotate_httpd $rc_local $sudoers $syslog $crontab $sshd $lilo $inittab $inetd ;do 
		ssh $host "cp -v $i $velhos"
	done

	echo "## acertando e copiando arquivo do sshd"
	scp $host:$sshd conf_so
	sed "s+#PermitRootLogin yes+PermitRootLogin no+g" conf_so/sshd_config >$sshd_novo
	scp $sshd_novo $host:$sshd

	echo "## acertando lilo.conf"
	scp $host:$lilo conf_so
	sed "s+timeout = 1200+timeout = 12+g" conf_so/lilo.conf >$lilo_novo
	scp $lilo_novo $host:$lilo
	ssh $host lilo

	echo "## acertando inittab"
	scp $host:$inittab conf_so
	sed "s+ca::ctrlaltdel:/sbin/shutdown -t5 -r now+#ca::ctrlaltdel:/sbin/shutdown -t5 -r now+g" conf_so/inittab >$inittab_novo
	scp $inittab_novo $host:$inittab
	ssh $host "telinit q"

	echo "## copiando demais arquivos novos"
	scp conf_so/logrotate.squid $host:$logrotate_squid
	scp conf_so/logrotate.syslog $host:$logrotate_syslog
	scp conf_so/logrotate.httpd $host:$logrotate_httpd
	scp conf_so/rc.local $host:$rc_local
	scp conf_so/sudoers $host:$sudoers
	scp conf_so/syslog.conf $host:$syslog
	scp conf_so/inetd.conf $host:$inetd
	scp -r scripts/ $host:/root

	echo "## acertando crontab"
	ssh $host "cat scripts/crontab >>$crontab"

	echo "## final funcconfso ##"
}

funcconffirewall () {
	echo "## inicio funcconffirewall ##"

	echo "## declaracao de variaveis"
	fwin="/etc/rc.d/rc.firewall"
	fwin_pad="firewall/rc.firewall.padrao"
	fwin_final="firewall/rc.firewall.$cliente.$data"

	echo "## acertando arquivo rc.firewall" 
	sed "s+redelocal=+redelocal=$subnet.0/24+g" $fwin_pad >$fwin_pad.1
	sed "s+broadcast=+broadcast=$subnet.255+g" $fwin_pad.1 >$fwin_pad.2
	sed "s+fwin=+fwin=$subnet.1+g" $fwin_pad.2 >$fwin_pad.3
	sed "s+fwin_ext=+fwin_ext=$subnet.1+g" $fwin_pad.3 >$fwin_final
	chmod 755 $fwin_final
	scp $fwin_final $host:$fwin

	echo "## final funcconffirewall ##"
}

funcconfdhcp () {
	echo "## inicio funcconfdhcp ##"

	echo "## declaracao de variavies ##"
	dhcp_conf="conf_so/dhcpd.conf.$cliente"
	dhcpd="/etc/dhcpd.conf"
	dhcp_mascara="255.255.255.0"
	dhcp_donimio="$cliente"
	dhcp_router="$subnet.1"
	dhcp_inicio="$subnet.21"
	dhcp_final="$subnet.200"
	dhcp_broadcast="$subnet.255"	

	echo "## criando arquivo de configuracao"
	echo "# dhcpd.conf
ddns-update-style none;
default-lease-time 40000000;
max-lease-time 41000000;
option subnet-mask $dhcp_mascara;
option broadcast-address $dhcp_broadcast;
option routers $dhcp_router;
option domain-name-servers 200.204.0.10, 200.204.0.138;
option domain-name "$cliente";

subnet $subnet.0.0 netmask $dhcp_mascara {
	range $dhcp_inicio $dhcp_final;
}" >>$dhcp_conf

	echo "## copiando arquivo de configuracao para o servidor"
	scp $dhcp_conf $host:$dhcpd

	echo "## final funcconfdhcp ##"
}

funcconfhorario() {
	echo "## inicio funcconfhorario ##"
	
	echo "## declarando variavies ##"
	localtime="/etc/localtime"
	arquivozic="tz-brasil-sp.zic"
	localtimevelho="/root/velhos"
	localtimenovo="/usr/share/zoneinfo/America/Sao_Paulo"
	
	echo "## fazendo backup do localtime atual ##"
	ssh $host "cp -v $localtime $localtimevelho"
	
	echo "## configurando novo arquivo de time zone ##"
	scp conf_so/$arquivozic $host:/root/scripts
	ssh $host "zic /root/scripts/$arquivozic
	ssh $host "rm -frv /etc/localtime"
	ssh $host "ln -s $localtimenovo $localtime"
	ssh $host "date `date +%m%d%H%M%Y`"
	ssh $host "hwclock --systohc"

	echo "## final funcconfhorario ##"
}

funcconfnetsnmp () {
	echo "## inicio funcconnetsnmp ##"
	
	echo "## declarando variavies ##"
	zipnetsnmp="/home/downloads/softwares/net-snmp/$versaonetsnmp.tar.gz"
	configurenetsnmp="cd $homeinstall;tar xvzf $versaonetsnmp.tar.gz; cd $versaonetsnmp ; ./configure --prefix=/usr/local/$versaonetsnmp && make && make install"
	snmpconf="/usr/local/$versaonetsnmp/share/snmp/snmpd.conf"
	snmpconf_novo="conf_so/snmpd.conf"
	inicia_snmpd="/usr/local/net-snmp-5.4/sbin/snmpd"
	
	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipnetsnmp $host:$homeinstall
	
	echo "## instalando net-snmp ##"
	ssh $host $configurenetsnmp
	scp $snmpconf_novo $host:$snmpconf
	ssh $host $inicia_snmpd
	
	echo "## final funcconnetsnmp ##"
}

funcconfgd() {
	echo "## inicio funcconfgd ##"

	echo "## declarando variavies ##"
	zipgd="/home/downloads/softwares/libgd/$versaogd.tar.bz2"
	configuregd="cd $homeinstall;tar xvjf $versaogd.tar.bz2; cd $versaogd ; ./configure --prefix=/usr/local/$versaogd && make && make install"
	
	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipgd $host:$homeinstall
	
	echo "## instalando libgd ##"
	echo "$configuregd"
	#ssh $host $configuregd
	echo "esperando para instalar....."
	read espera
	
	echo "## final funcconfgd ##"
}

funcconfmrtg() {
	echo "## inicio funcconfmrtg ##"

	echo "## declarando variavies ##"
	zipmrtg="/home/downloads/softwares/mrtg/$versaomrtg.tar.gz"
	configuremrtg="cd $homeinstall;tar xvzf $versaomrtg.tar.gz; cd $versaomrtg ; ./configure --prefix=/usr/local/$versaomrtg --with-gd=/usr/local/$versaogd --with-gd-lib=/usr/local/$versaogd/lib --with-gd-inc=/usr/local/$versaogd/include && make && make install"
	cfgmaker="/usr/local/$versaomrtg/bin/cfgmaker-fwin-$cliente.sh"
	mrtgbin="/usr/local/$versaomrtg/bin/mrtg $cfgdir/fwin-$cliente.cfg"
	workdir="/var/www/htdocs/admin/mrtg"
	cfgdir="/usr/local/$versaomrtg/cfg"
	
	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipmrtg $host:$homeinstall
	
	echo "## instalando mrtg"
	ssh $host $configuremrtg
	
	echo "## configurando cfgmaker ##"
	ssh $host "echo /usr/local/$versaomrtg/bin/cfgmaker --global \'WorkDir: $workdir/fwin-$cliente\' \\\ >$cfgmaker"
	ssh $host "echo --global \'Options[_]: bits,growright\' \\\ >>$cfgmaker"
	ssh $host "echo --output $cfgdir/fwin-$cliente.cfg \\\ >>$cfgmaker"
	ssh $host "echo	web_get@localhost >>$cfgmaker"
	ssh $host "chmod 700 $cfgmaker"
	
	echo "## criando diretorios cfg e http ##"
	ssh $host "if ! [ -d $workdir ]; then mkdir -p $workdir/fwin-$cliente;fi"
	ssh $host "if ! [ -d $cfgdir ]; then mkdir $cfgdir;fi"
	
	echo "## executando o cfgmaker e as statisticas do mrtg ##"
	ssh $host $cfgmaker
	ssh $host "for i in 1 2 3;do $mrtgbin;done" 

	echo "## final funcconfmrtg ##"
}

funcconfntop () {
	echo "## inicio funcconfntop ##"

	echo "## declarando variavies ##"
	zipntop="/home/downloads/softwares/ntop/$versaontop.tgz"
	configurentop="cd $homeinstall;tar xvzf $versaontop.tgz; cd $versaontop ; ./configure --prefix=/usr/local/$versaontop --with-gd-root=/usr/local/$versaogd --with-gd-lib=/usr/local/$versaogd/lib --with-gd-include=/usr/local/$versaogd/include && make && make install"
	
	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipntop $host:$homeinstall
	
	echo "## instalando ntop"
	ssh $host $configurentop
	ssh $host "groupadd ntop"
	ssh $host "useradd ntop -g ntop"
	ssh $host "chown -R ntop.ntop /usr/local/$versaontop/share/ntop /usr/local/$versaontop/var"
	#ssh $host "echo ntop | passwd --stdin ntop"
}

funcconfbd () {
	echo "## inicio funcconfbd ##"

	echo "## declarando variavies ##"
	zipbd="/home/downloads/softwares/berkeley/$versaobd.tar.gz"
	configurebd="cd $homeinstall;tar xvzf $versaobd.tar.gz; cd $versaobd/build_unix/ ; ../dist/configure --prefix=/usr/local/$versaobd && make && make install"
	
	echo "## criando diretorio de instalacao e copiando arquivos fonte"
	ssh $host "if ! [ -d $homeinstall ]; then mkdir $homeinstall;fi"
	scp $zipbd $host:$homeinstall
	
	echo "## instalando bd"
	ssh $host $configurebd
}

if [ -z $2 ];then  
	echo "Digitar: ./comando root@host cliente"
	exit 0
fi
host="$1"
cliente="$2"
subnet="192.168.0"
versaosquid="squid-2.6.STABLE13"
versaosquidGuard="squidGuard-1.2.0"
versaocalamaris="calamaris-2.59"
versaobd="db-2.7.7"
versaonetsnmp="net-snmp-5.4"
versaogd="gd-2.0.34"
versaomrtg="mrtg-2.15.1"
versaontop="ntop-3.2"
email="solutionlinux"
#versaonetsnmp="$6"
#versaogd="$7"
#versaomrtg="$8"
#versaontop="$9"
#echo -n "Digite a versao do berkeley db: "
#read versaobd
#echo -n "Digite a subnet: "
#read subnet
#echo -n "Digite o e-mail: "
#read email
#email="solutionlinux@gmail.com"
data=`date +%Y%m%d%H%M`
homeinstall="/root/install"
logokinstall="logsinstall/$cliente.$versaosquid.$versaosquidGuard.$versaocalamaris.$data.ok"
logerrinstall="logsinstall/$cliente.$versaosquid.$versaosquidGuard.$versaocalamaris.$data.err"

if [ ! -d logsinstall ];then
	mkdir logsinstall
fi

echo "Inicio da instalacao: `date`" >>$logokinstall 2>$logerrinstall

echo "funcconfsshroot"
funcconfsshroot >>$logokinstall 2>$logerrinstall
echo "funcconfbd"
funcconfbd >>$logokinstall 2>$logerrinstall
echo "funcconfsquidguard"
funcconfsquidguard >>$logokinstall 2>$logerrinstall
echo "funcconfsquid"
funcconfsquid >>$logokinstall 2>$logerrinstall
echo "funcconfapache"
funcconfapache >>$logokinstall 2>$logerrinstall
echo "funcconfusuario"
funcconfusuario >>$logokinstall 2>$logerrinstall
echo "funcconfso"
funcconfso >>$logokinstall 2>$logerrinstall
echo "funcconfhorario"
funcconfhorario >>$logokinstall 2>$logerrinstall
echo "funcconffirewall"
funcconffirewall >>$logokinstall 2>$logerrinstall
echo "funcconfdhcp"
funcconfdhcp >>$logokinstall 2>$logerrinstall
echo "funcconfnetsnmp"
funcconfnetsnmp >>$logokinstall 2>$logerrinstall
echo "funcconfgd"
funcconfgd >>$logokinstall 2>$logerrinstall
echo "funcconfmrtg"
funcconfmrtg >>$logokinstall 2>$logerrinstall
echo "funcconfntop"
#funcconfntop >>$logokinstall 2>$logerrinstall

echo "Final da instalacao: `date`" >>$logokinstall 2>$logerrinstall
