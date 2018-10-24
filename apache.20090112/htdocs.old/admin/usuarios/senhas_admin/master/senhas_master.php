<?php
include '../../../header.php';
$s_usuario = $_POST['usuario'];
$s_nova_senha = $_POST['nova_senha'];
$s_confirma_nova_senha = $_POST['confirma_nova_senha'];

$c_nova_senha = crypt($s_nova_senha);
$c_confirma_nova = crypt($s_confirma_nova);

include "../../config/config.php";

if ( empty ( $s_usuario ) ) {
        echo "Usuario Invalido<br>";
        $log_nok = "usuarionok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
        include '../../../rodape.php';
        exit;
}

foreach($arquivo as $linha) {
	list ($a_usuario, $a_senha, $a_flag ) = split (':', $linha);
		if ( $s_usuario == $a_usuario ) {
			if ( $s_nova_senha == $s_confirma_nova_senha ) {
				$linha = "$s_usuario:$c_nova_senha:$a_flag";
				exec ("$htpasswd -b $arquivo_usuarios $s_usuario $s_nova_senha");
				echo "A senha do usuario <b>$s_usuario</b> foi alterada com sucesso<br>";
			}else{
				echo "Campos Nova Senha e Confirma Senha estao diferentes";
			}
			$flag = "ok";
		}else{
			//echo "naum foi";
			//header ("Location: http://192.168.1.250/admin/usuarios/senhas_admin/master/senhas_master.html");
		}
	$linha1 = trim($linha);
	//system ("echo '$linha1:1' >>$arquivo_caminho1");
	system ("echo '$linha1' >>$arquivo_caminho1");
}
if ( $flag <> "ok" ) {
	echo "Usuario Invalido<br>";
        $log_nok = "usuarionok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
}
exec ("mv -f $arquivo_caminho1 $arquivo_caminho");
//echo "<a href=senhas_master.html>Voltar</a><br>a<br>$htpasswd<br>b";
include '../../../rodape.php';
?>
