<?
include '../../header.php';
include '../config/config_url.php';

if ( empty ( $s_usuario ) ) {
        echo "Usuario Invalido<br>";
        $log_nok = "usuarionok - $s_usuario - $log";
        system ("echo '$log_nok' >>$arquivo_log");
        include '../../rodape.php';
        exit;
}

if ( is_dir ("$dir")) {
	foreach ($lista_completa as $linha => $linha1) {
		if ( "$linha1" == "$s_url" ) {
			echo "A URL <b>$s_url</b> ja esta na lista do usuario <b>$s_usuario</b>";
			$flag = "sim";
		}
	}
	if ( $flag == "nao" ) {
		$url = `echo $s_url >> $lista`;
		$final = `tail -n 1 $lista`;
		echo "A URL <b>$final</b> foi includa na lista do usuario <b>$s_usuario</b> com sucesso.<br>";
	}
}else{
	echo "O usuario $s_usuario nao existe.";
}
include '../../rodape.php';
?>

