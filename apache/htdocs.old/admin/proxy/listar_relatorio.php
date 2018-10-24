<?php
include '../header.php';
include './config/config_calamaris.php';
//header ("Location: $url_logs/$ano/$mes/diario$ano$mes$dia.html");
echo "<table border=1>";
for ($i = 1 ; $i <= 31 ; $i++ ) {
		if ( $i < 10 ) {
			$dia = "0$i";
		}else{
			$dia = "$i";
		}
		$arq = `ls $caminho_logs$ano/$mes/diario$ano$mes$dia.html`;
	if ( $arq <> "" ) {
		echo "<tr><td><a href=$url_logs/$ano/$mes/diario$ano$mes$dia.html>Relatorio gerado em $dia/$mes/$ano</td></tr>";
	}
	//echo "$i - $dia - $arq";
}
echo "</table>";
include '../rodape.php';
?>

