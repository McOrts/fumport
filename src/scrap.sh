#!/bin/bash
#########################################################################
# Autor: Martí Vich                                                     #
# Data: 11/11/2022                                                      #
# Versió: 1.1                                                           #
# Objecte: Scrapping dels vaixells amarrats al port de Palma		#
#									#
# Input: https://www.myshiptracking.com/				#
# Output: resultat_<ID_PORT>_<ID_CLASSE>.csv							#
# Usage: . scrap.sh							#
#									#
#########################################################################

#PORT A ESCANEJAR
#Palma de Mallorca
port=333
#Barcelona
#port=98
#València
#port=434
#Vigo
#port=440
#Bilbao
#port=1881
#Tarragona
#port=1897

#CLASSE DELS VAIXELLS
#Passatger
classe=6_511
#Cargo
#classe=7_511
#Petroler
#classe=8_511
#Vela
#classe=9_511
#Pesca
#classe=10_511


#FITXER RESULTANT
fitxer='resultat_'$port'_'$classe.csv
#Comprovam que no existeixi el fitxer de resultats
if [ -f $fitxer ]
then
	rm $fitxer
fi


#Cercam dins les pàgines que tenen els vaixells. Començam per la primera
pagina=1
#Descarregam la pagina corresponent
curl -s 'https://www.myshiptracking.com/inport?sort=TIME&page='$pagina'&pid='$port > page$pagina.html
#Mentre hi hagin vaixells a la pàgina (comptam si les linies són més grans que 900, ja que si no hi ha vaixells val 800 i pico)
while [ `cat page$pagina.html | wc -l` -gt 900 ]
do
	#Collim el nom del vaixell
	cat page$pagina.html | grep "icon"$classe".png" | awk -F '>' '{print $5}' | awk -F '</a' '{print $1}' > ships$pagina.txt
	#Collim la data
	cat page$pagina.html | grep -A15 "icon"$classe".png" | grep -A1 'UTC' | grep '<b>' | cut -f 2 -d ">" | cut -f1 -d "<" | cut -f1 -d " " > data$pagina.txt
	#Collim l'hora
	cat page$pagina.html | grep -A15 "icon"$classe".png" | grep -A1 'UTC' | grep '<b>' | cut -f 3 -d ">" | cut -f1 -d "<" > hora$pagina.txt
	#Collim l'eslora
	cat page$pagina.html | grep -A15 "icon"$classe".png" | grep 'm<' | cut -f 2 -d '>' | cut -f 1 -d '<' | cut -f1 -d " " > eslora$pagina.txt

	#Juntam les dades en un fitxer separat per ;
	paste -d ";" ships$pagina.txt data$pagina.txt hora$pagina.txt eslora$pagina.txt >> $fitxer
	
	#Esborram els fitxers temporals
	rm *.html
	rm *.txt
	
	#Aumemtam la pàgina i la descarregam
	pagina=$[pagina+1]
	curl -s 'https://www.myshiptracking.com/inport?sort=TIME&page='$pagina'&pid='$port > page$pagina.html
done
#Esborram el darrer fitxer temporal
rm *.html
