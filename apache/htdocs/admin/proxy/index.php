<?php
include '../header.php';
include './config/config_calamaris.php';
?>
<table width=90% align=center valign=middle>
	<form action="listar_relatorio.php" method="POST">
	<tr>
                <td><a href=./logs/diario.html>Log Diario do Squid</a></td>
                </td>
		<td>Mes: <select name="mes">
		<?php
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
		<?php
			foreach ($lista_ano as $ano => $ano1 ) {
				trim ( $ano1 );
				if ( $ano1 <> "" ) {
					echo "<option value=$ano1>$ano1</option>";
				}
			}
		?>
		</select></td>
		<td><input type="submit" name="envia" value="Ver Lista Diario"></td>
        </tr>
    </form>
	<form action="listar_relatorio.php" method="POST">
	<th colspan=4><hr></th>
	<tr>
		<td><a href=./logs/semanal.html>Log Semanal do Squid</a></td>
		<td>Mes: <select name="mes">
		<?php
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
		<?php
			foreach ($lista_ano as $ano => $ano1 ) {
				trim ( $ano1 );
				if ( $ano1 <> "" ) {
					echo "<option value=$ano1>$ano1</option>";
				}
			}
		?>
		</select></td>
		<td><input type="submit" name="envia" value="Ver Lista Semanal"></td>
        </tr>
    </form>
	</tr>
</table>
<?php
include '../rodape.php';
?>
