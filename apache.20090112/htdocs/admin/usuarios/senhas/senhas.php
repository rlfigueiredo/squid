<?php
$s_usuario = $_POST['usuario'];
$s_senha_atual = $_POST['senha_atual'];
$s_nova_senha = $_POST['nova_senha'];
$s_confirma_nova_senha = $_POST['confirma_nova_senha'];
$usuario_ok = "nao";

$c_senha_atual = crypt($s_senha_atual);
$c_nova_senha = crypt($s_nova_senha);
$c_confirma_nova = crypt($s_confirma_nova);

$arquivo = file('/var/squid/listas/.usuarios_php');
$arquivo_caminho = "/var/squid/listas/.usuarios_php";
$arquivo_caminho1 = "/var/squid/listas/.usuarios1_php";
$arquivo_usuarios = "/var/squid/listas/.usuarios";
$arquivo_log = "/var/squid/listas/.usuarios_php_senhas.log";
$data = date ("d/m/y - H:i:s");
$log = "$_SERVER[REMOTE_ADDR] - $_SERVER[SCRIPT_NAME] - $data ";

if ( empty ( $s_usuario ) ) {
	echo "Usuario Invalido<br>";
	$log_nok = "usuarionok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
        echo "<a href=index.html>Voltar</a><br>";
        exit;
}
if ( empty ( $s_senha_atual ) ) {
	echo "Senha Atual Invalida<br>";
	$log_nok = "senhaatualnok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
        echo "<a href=index.html>Voltar</a><br>";
	exit;
}
if ( empty ( $s_nova_senha ) ) {
	echo "Nova Senha Invalida<br>";
	$log_nok = "novasenhanok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
        echo "<a href=index.html>Voltar</a><br>";
        exit;
}
if ( empty ( $s_confirma_nova_senha ) ) {
	echo "Confirma Senha Invalida<br>";
	$log_nok = "confirmanovasenhanok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
        echo "<a href=index.html>Voltar</a><br>";
	exit;
}

foreach($arquivo as $linha) {
	list ($a_usuario, $a_senha, $a_flag ) = split (':', $linha);
		$a_flag = "1";
		if ( $s_usuario == $a_usuario ) {
			$usuario_ok = "sim";
			if ( crypt($s_senha_atual,$a_senha) == $a_senha ) {
				if ( $s_nova_senha == $s_confirma_nova_senha ) {
					$a_flag = "1";
					$linha = "$s_usuario:$c_nova_senha:$a_flag";
					exec ("/usr/bin/htpasswd -b $arquivo_usuarios $s_usuario $s_nova_senha");
					echo "Sua senha foi alterada com sucesso<br>";
					$log_ok = "ok - $s_usuario - $log";
        				system ("echo '$log_ok' >>$arquivo_log");
					//echo "<a href=http://intraredes01>Intranet</a>";
				}else{
					echo "Campos Nova Senha e Confirma Senha estao diferentes<br>";
					$log_nok = "senhasdiferentesnok - $s_usuario - $log";
        				system ("echo '$log_nok' >>$arquivo_log");
					echo "<a href=index.html>Voltar</a><br>";
				}
			}else{
				echo "Senha Atual Incorreta<br>";
				$log_nok = "senhaatualnok - $s_usuario - $log";
        			system ("echo '$log_nok' >>$arquivo_log");
				echo "<a href=index.html>Voltar</a><br>";
			}
		}else{
		}
	$linha1 = trim($linha);
	system ("echo '$linha1' >>$arquivo_caminho1");
}
if ( $usuario_ok == "nao" ) {
	echo "Usuario incorreto<br>";
	$log_nok = "usuarionok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
	echo "<a href=index.html>Voltar</a><br>";
}
exec ("mv -f $arquivo_caminho1 $arquivo_caminho");
exit;
?>
