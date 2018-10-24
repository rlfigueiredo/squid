#!/bin/bash

corpo=""
limite="80"

for i in `df -h | awk '{print $5}' | awk -F "%" '{print $1}'`;do
	if [ "$i" != "Use" ] && [ $i -gt $limite ] ; then
		corpo="$corpo $i"
	fi
done

if [ ! -z "$corpo" ];then
	echo "Particao(oes) acima do limite de $limite% :"
	echo ""
	for i in `echo $corpo`;do
		df -h | grep $i
	done 
	echo ""
	echo `date`
fi | if [ ! -z "$corpo" ];then mail -s"Verificar Espaco em Disco - `hostname`" solutionlinux@gmail.com ;fi
