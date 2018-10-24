<?php
include '../../../header.php';
include '../../config/config_url.php';

$cont = 0;
$cont_url = 0;
?>
<head>
</head>
<body>
<table border = "0" align = "center">
	<th colspan=2>URLs excluídas com sucesso</th>
        <tr><td>&nbsp</td><td>&nbsp</td></tr>
	<tr>
                <td align = "left" width = "30%">Urls Excluidas: </td>
		<td>
		<?php
			foreach ($lista_completa as $linha => $linha1) {
				trim ($linha1);
				if ( $linha1 <> "" ) {
					if ( $linha1 == $_POST["$cont_url"] ) {
						echo "$linha1<br>";
						$criterio[$cont] = "$linha1";
						$cont++;
					}
				}
				$cont_url++;
			}
			if ( $cont == 0 ) {
				echo "Nenhuma URL para o usuario <b>$s_usuario</b>.";
			} else {
				system ("touch $lista.nova");
				foreach ($lista_completa as $linha => $linha1) {
					foreach ($criterio as $cada_url => $cada_url1 ) {
						if ( $linha1 == $cada_url1 ) {
							system ("echo $linha1 >>$dir_backup/$s_usuario.domains.excluidas.$data");
							$linha1 = "";
							trim ($linha1);
						}
					}
					if ( $linha1 <> "" ) {
						if ( ! is_dir ("$dir_backup") ) {
							system ("mkdir -p $dir_backup");
						}
						system ("echo $linha1 >>$lista.nova");
					}
				}
				system ("cp $lista $dir_backup/$s_usuario.domains.$data");
				system ("mv $lista.nova $lista");
			}
?>
		</td>
	</tr>
</table>
<?php
include '../../../rodape.php';
?>

