#!/bin/bash
## Este script tem como finalidade sincronizar o horario do servidor
## com o horario disponibilizado pelo site http://www.horacerta.com.br
## Para automatizar o procedimento basta incluir este script na crontab
## do root no servidor desejado. 
## As informa��es referente � execu��o do script s�o enviadas 
## para a sa�da padr�o 
## Autor: Rogerio rlfigueiredo@gmail.com
## data: 26.02.2007

## Declara��o da vari�vel referente ao horario da cidade desejada
cidade="Sao_Paulo"

## Declara��o da vari�vel referente ao arquivo temporario
## onde os dados da pagina ser�o baixados
arqtemp="/tmp/horacerta"

## Executa o download do arquivo contendo data e hora
wget http://www.horacerta.com.br/cgi-bin/horacerta.cgi?cidade=$cidade -O $arqtemp

## Executa um filtro no arquivo baixado criando uma vari�vel
## com os dados necess�rios para efetuar o ajuste
fonte=`cat /tmp/horacerta | awk -F "name=\"mostrador\"" '{print $2}' | awk -F "value=" '{print $2}' | awk -F "\"" '{print $2}'`

## Verifica se a vari�vel $fonte � vazia
## se sim o script aborta sua execu��o e o hor�rio n�o � atualizado
if [ -z "$fonte" ];then
	echo "Arquivo de origem vazio"
	exit 0
fi

## Filtra a data com base na vari�vel $fonte
data=`echo $fonte | awk '{print $1}'`

## Filtra a hora com base na vari�vel $fonte
horario=`echo $fonte | awk '{print $3}'`

## Filtra o per�odo (AM/PM) com base na vari�vel $fonte
ampm=`echo $fonte | awk '{print $4}'`

## Filtra dia mes e ano com base na vari�vel $data
dia=`echo $data | awk -F "/" '{print $1}'`
mes=`echo $data | awk -F "/" '{print $2}'`
ano=`echo $data | awk -F "/" '{print $3}'`

## Filtra hora minuto e segundo com base na vari�vel $horario
hora=`echo $horario | awk -F ":" '{print $1}'`
minuto=`echo $horario | awk -F ":" '{print $2}'`
segundo=`echo $horario | awk -F ":" '{print $3}'`

## Converte a sigla do m�s para num�rico
case $mes in 
	jan) mes=01 ;;
	fev) mes=02 ;;
	mar) mes=03 ;;
	abr) mes=04 ;;
	mai) mes=05 ;;
	jun) mes=06 ;;
	jul) mes=07 ;;
	ago) mes=08 ;;
	set) mes=09 ;;
	out) mes=10 ;;
	nov) mes=11 ;;
	dez) mes=12 ;;
esac

## Acerta os dias menores que 10
if [ $dia -le 10 ] ; then
	dia=0$dia
fi

## Converte a hora para o padr�o correto de acordo com 
## o per�odo correto
if [ $ampm == "PM" ] && [ $hora != "12" ] ; then
	for ((i=1,j=13 ; $i <= 11 ; i=$i+1, j=$j+1 )) ;do
		if [ $i -le 9 ];then
			horacerta="0$i"
			#echo "$horacerta"
		else
			horacerta="$i"
			#echo "$horacerta"
		fi
		if [ $hora == $horacerta ];then
			case $horacerta in
				01) horacerta=$j ;;
				02) horacerta=$j ;;
				03) horacerta=$j ;;
				04) horacerta=$j ;;
				05) horacerta=$j ;;
				06) horacerta=$j ;;
				07) horacerta=$j ;;
				08) horacerta=$j ;;
				09) horacerta=$j ;;
				10) horacerta=$j ;;
				11) horacerta=$j ;;
			esac
			echo $horacerta
			hora=$horacerta
		fi
	done
elif [ $ampm == "AM" ] && [ $hora == "12" ] ; then
	hora="00"
fi

## Exibe a diferen�a entre a hora do servidor local
## e a hora obtida do site 
echo "###########################"
echo "Site : $mes$dia$hora$minuto$ano.$segundo"
echo "Local: `date +%m%d%H%M%Y.%S`"
echo "###########################"

## Verifica se a hora local e a hora obtida do site s�o diferentes
## se sim atualiza o hor�rio local com base nas informa��es obtidas
## do site
if [ "$mes$dia$hora$minuto$ano" != "`date +%m%d%H%M%Y`" ] ;then
	echo "diferentes acertando..."
	date $mes$dia$hora$minuto$ano.$segundo && hwclock --systohc && hwclock
	cat /root/scripts/horacerta.sh.log | mail -s" `hostname` - Hora Certa" solutionlinux@gmail.com
fi