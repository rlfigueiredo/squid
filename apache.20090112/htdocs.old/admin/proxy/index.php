<?
include '../header.php';
include './config/config_calamaris.php';
?>
<table width=90% align=center valign=middle>
	<form action="listar_relatorio.php" method="POST">
	<tr>
                <td><a href=./logs/diario.html>Log Diario do Squid</a></td>
                </td>
		<!--td>Dia: <select name="dia"-->
		<?
		//	for ($dia=1 ; $dia <= 31 ; $dia++ ) {
		//		$diacerto = $dia + 1  ;
		//		$diaok = "$diacerto";
		//		if ( $dia < 10 ) {
		//			echo "<option value=0$diaok>0$dia</option>";
		//		}else{
		//			echo "<option value=$diaok>$dia</option>";
		//		}
		//	}
		//?>
		<!--/select></td-->
		<td>Mes: <select name="mes">
		<?
			for ($mes=1 ; $mes <= 12 ; $mes++ ) {
				if ( $mes < 10 ) {
					echo "<option value=0$mes>0$mes</option>";
				}else{
					echo "<option value=$mes>$mes</option>";
				}
			}
		?>
		</select></td>
		<td>Ano: <select name="ano">
		<?
			foreach ($lista_ano as $ano => $ano1 ) {
				trim ( $ano1 );
				if ( $ano1 <> "" ) {
					echo "<option value=$ano1>$ano1</option>";
				}
			}
		?>
		</select></td>
		<td><input type="submit" name="envia" value="Ver Lista"></td>
        </tr>
	<tr>
		<td><a href=./logs/semanal.html>Log Semanal do Squid</a></td>
	</tr>
</table>
<?
include '../rodape.php';
?>
