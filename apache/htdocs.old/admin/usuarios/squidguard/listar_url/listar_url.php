<?php
include '../../../header.php';
include '../../config/config_url.php';
$cont = 0;

if ( $s_usuario == "blacklist" ) {
	echo "Lista de URL's bloqueadas para todos usuarios:<br><br>";
}elseif ( $s_usuario == "todos" ) {
	echo "Lista de URL's liberadas para todos usuarios:<br><br>";
}else{
	echo "Lista de URL's que podem ser acessadas somente pelo usuario <b>$s_usuario</b>:<br><br>";
}
foreach ($lista_completa as $linha => $linha1) {
		if ( $linha1 <> "" ) {
			echo "URL: <b>$linha1</b><br>";
			$cont++;
		}
}
if ( $cont == 0 ) {
	echo "Nenhuma URL para o usuario <b>$s_usuario</b>.";
}
include '../../../rodape.php';
?>

