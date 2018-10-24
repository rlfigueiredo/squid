<?php
include '../../../header.php';
$s_nome = $_POST['nome'];
$s_usuario = trim ( strtolower ($_POST['usuario']) );
$s_nova_senha = $_POST['nova_senha'];
$usuario_existe = "nao";

$c_nova_senha = crypt($s_nova_senha);

$arquivo = file('/var/squid/listas/.usuarios_php');
$arquivo_caminho = "/var/squid/listas/.usuarios_php";
$arquivo_caminho1 = "/var/squid/listas/.usuarios1_php";
$arquivo_usuarios = "/var/squid/listas/.usuarios";
$arquivo_log = "/var/squid/listas/.usuarios_php_senhas.log";
$htpasswd = "/usr/bin/htpasswd";
$dir_listas = "/var/squid/listas/";

$data = date ("d/m/y - H:i:s");
$log = "$_SERVER[REMOTE_ADDR] - $_SERVER[REMOTE_HOST] - $_SERVER[PHP_AUTH_USER] - $_SERVER[SCRIPT_NAME] - $data ";

if ( empty ( $s_nome ) ) {
	echo "Nome do Usuario Invalido<br>";
	$log_nok = "nomenok - $s_usuario - $log";
       	system ("echo '$log_nok' >>$arquivo_log");
	include '../../../rodape.php';
	exit;
}	
if ( empty ( $s_usuario ) ) {
	echo "Usuario Invalido<br>";
	$log_nok = "usuarionok - $s_usuario - $log";
       	system ("echo '$log_nok' >>$arquivo_log");
	include '../../../rodape.php';
	exit;
}	
if ( empty ( $s_nova_senha ) ) {
	echo "Senha Invalida<br>";
	$log_nok = "senhanok - $s_usuario - $log";
       	system ("echo '$log_nok' >>$arquivo_log");
	include '../../../rodape.php';
	exit;
}	

foreach($arquivo as $linha) {
	list ($a_usuario, $a_senha, $a_flag ) = split (':', $linha);
		$a_flag = "1";
		if ( $s_usuario == $a_usuario ) {
			$usuario_existe = "sim";
		}
}
if ( $usuario_existe == "nao" ) {
	$linha = "$s_usuario:$c_nova_senha:$s_nome:$a_flag";
	exec ("$htpasswd -b $arquivo_usuarios $s_usuario $s_nova_senha");
	$linha1 = trim($linha);
	system ("echo '$linha1' >>$arquivo_caminho");
	system ("mkdir $dir_listas$s_usuario");
	system ("touch $dir_listas$s_usuario/domains $dir_listas$s_usuario/urls $dir_listas$s_usuario/expressions");
	$log_ok = "ok - $s_usuario - $log";
	system ("echo '$log_ok' >>$arquivo_log");
	echo "Usuario criado com sucesso.<br>";
}else{
	echo "Usuario <b>$s_usuario</b> ja existe<br>";
	$log_nok = "nok - $s_usuario - $log";
	system ("echo '$log_nok' >>$arquivo_log");
}
include '../../../rodape.php';
?>
