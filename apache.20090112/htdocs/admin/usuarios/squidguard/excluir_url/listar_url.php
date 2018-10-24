<?
include '../../../header.php';
include '../../config/config_url.php';
$cont = 0;
?>
<head>
</head>
<body>
<table border = "0" align = "center">
	<form action="excluir_url.php" method="POST">
	<!-- form action="excluir_url.php" method="GET" -->
	<th colspan=2>Selecione as URLs que serão excluídas:</th>
	<tr><td>&nbsp</td><td>&nbsp</td></tr>
	<tr>
                <td align = "left" width = "30%">Urls do usuario: </td>
		<td>
		<?
			echo "<input type='hidden' name='usuario' value='$s_usuario'>";
			foreach ($lista_completa as $linha => $linha1) {
				trim ($linha1);
				if ( $linha1 <> "" ) {
					echo "<input type='checkbox' name='$cont' value='$linha1'>$linha1<br>";
					$cont++;
				}
			}
		
if ( $cont == 0 ) {
	echo "Nenhuma URL para o usuario <b>$s_usuario</b>.";
	echo "</td>";
} else {
	echo "</td>";
	echo "<td><input type='submit' name='envia' value='Excluir'></td>";
}
?>
	</tr>
</table>
<?
include '../../../rodape.php';
?>

