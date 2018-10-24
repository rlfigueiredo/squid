<?php
include '../header.php';

$acao = $_POST['acao'];
$host = `hostname`;

if ( $acao === "ativarregras" ) {
	system ("sudo /usr/sbin/iptables -t nat -I PREROUTING -p tcp --dport 3000 -j ACCEPT && sudo /usr/sbin/iptables -I INPUT -p tcp --dport 3000 -j ACCEPT");
	echo "<a href='http://$host.no-ip.org:3000/'>Acessar Ntop</a>";
}else if ( $acao === "restaurarpadrao" ) {
	//$teste = `sudo /usr/sbin/iptables -L -n -v --line-numbers | grep "dpt:3000" | awk '{print $1}'`;
	system ("sudo /etc/rc.d/rc.firewall");
	echo "Regras restauradas com sucesso.";
}

include '../rodape.php';
?>
