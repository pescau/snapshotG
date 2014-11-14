#!/bin/sh
#Prueba de concepto
echo '~~~~~~~~ MV ~~~~~~~~~~~~~~~~~'
mv -v testback/5/ testback/tmp
mv -v testback/4/ testback/5
mv -v testback/3/ testback/4
mv -v testback/2/ testback/3
mv -v testback/1/ testback/2
mv -v testback/0/ testback/1
mv -v testback/tmp/ testback/0
echo '~~~~~~~~~~~ CP ~~~~~~~~~~~~~~'
cp -v -al testback/1/. testback/0
echo '~~~~~~~~~~~ RSYNC ~~~~~~~~~~~~~~'
rsync -av --delete --numeric-ids orig/ testback/0/

# Ver si el archivo de control está cambiando:
echo '~~~~~~~~~~~ CHECK ~~~~~~~~~~~~~~'
echo orig/ls.txt: ;cat orig/ls.txt
echo
echo testback/0/ls.txt: ; cat testback/0/ls.txt
echo testback/1/ls.txt: ; cat testback/1/ls.txt
echo testback/2/ls.txt: ; cat testback/2/ls.txt
echo testback/3/ls.txt: ; cat testback/3/ls.txt
echo testback/4/ls.txt: ; cat testback/4/ls.txt
echo testback/5/ls.txt: ; cat testback/5/ls.txt
