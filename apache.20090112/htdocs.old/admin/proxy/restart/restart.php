<?
include '../../header.php';

$infile = `ls /var/squid/listas`;
$dia = date ("d");
$mes = date ("m");
$ano = date ("Y");
$data = date ("YmdHis");
$dir_conf = "/var/squid/log/squidGuard/$ano/$mes/$dia";
system ("if [ ! -d $dir_conf ];then mkdir -p $dir_conf;fi");
$squidguard = "$dir_conf/squidGuard.conf.$data";
$squidguard_prod = "/usr/local/squidGuard-1.2.0/bin/squidGuard.conf";
##$squidguard_prod = "/usr/local/squidGuard-1.2.0/squidGuard.conf";
$pid_squid = "/var/squid/log/squid.pid";
$todos = split ( "\n", $infile);

system ("echo 'logdir /var/squid/log/squidGuard' >$squidguard");
system ("echo 'dbhome /var/squid/listas' >>$squidguard");
foreach ( $todos as $linha => $linha1 ) {
	trim ( $linha1 );
	if ( $linha1 <> "" && $linha1 <> "blacklist" && $linha1 <> "todos") {
		system ("echo 'src $linha1 {' >>$squidguard");
		system ("echo '	user	$linha1' >>$squidguard");
		system ("echo '	logfile	$linha1' >>$squidguard");
		system ("echo '}' >>$squidguard");
		system ("echo 'dest lista_$linha1 {' >>$squidguard");
		system ("echo '	domainlist	$linha1/domains' >>$squidguard");
		system ("echo '	urllist		$linha1/urls' >>$squidguard");
		system ("echo '	expressionlist	$linha1/expressions' >>$squidguard");
		system ("echo '}' >>$squidguard");
	}
}
system ("echo 'dest lista_todos {' >>$squidguard");
system ("echo '	domainlist      todos/domains' >>$squidguard");
system ("echo '	urllist         todos/urls' >>$squidguard");
system ("echo '	expressionlist  todos/expressions' >>$squidguard");
system ("echo '}' >>$squidguard");
system ("echo 'dest blacklist {' >>$squidguard");
system ("echo '	domainlist blacklist/domains' >>$squidguard");
system ("echo '	expressionlist blacklist/expressions' >>$squidguard");
system ("echo '}' >>$squidguard");
system ("echo 'acl {' >>$squidguard");
foreach ( $todos as $acls => $acl ) {
	trim ( $acl );
	if ( $acl <> ""  && $acl <> "blacklist" && $acl <> "todos") {
		system ("echo '	$acl {' >>$squidguard");
		system ("echo '		pass !blacklist lista_$acl lista_todos none' >>$squidguard");
		system ("echo '	}' >>$squidguard");
	}
}
system ("echo '	default {' >>$squidguard");
system ("echo '		pass !blacklist lista_todos none' >>$squidguard");
system ("echo '		redirect http://www.rogerio.ultraespaco.com/clientes/erro/squidGuard.php?clientaddr=%a&clientname=%n&clientident=%i&clientgroup=%s&destinationgroup=%t&url=%u' >>$squidguard");
system ("echo '	}' >>$squidguard");
system ("echo '}' >>$squidguard");
system ("cat $squidguard > $squidguard_prod");
system ("kill -HUP `cat $pid_squid`");
$log = `ps -ef | grep squid`;
$log1 = split ( "\n", $log );
foreach ( $log1 as $processos => $processos1 ) {
	echo "$processos1<br>";
}
include '../../rodape.php';
?>
