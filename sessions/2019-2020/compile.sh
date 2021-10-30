#!/bin/bash


while IFS=: read code nom
do
 echo "Agrément pour ${code}"
 pdflatex   -shell-escape "\newcommand\nom{${nom}}\input{agrement}" 
 mv agrement.pdf pdf/${code}.pdf
 rm -f *.log *.aux

done < 'agrees.txt'
