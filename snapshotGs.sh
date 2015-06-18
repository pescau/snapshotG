#!/bin/sh
########################################################
## CONFIGURACION
#Ejecutables:
cat="/bin/cat"
mv="/bin/mv "
cp="/bin/cp "
#echo="/usr/gnu/bin/echo"
stat="/usr/bin/stat -x"
date="/bin/date"
rsync="/usr/local/bin/rsync --exclude 'tmp' --exclude '/dev/' --exclude 'var/log' --exclude 'videos/*' -aHv --delete --numeric-ids  -e /usr/bin/ssh "

#'''''' Destinos:
dest_base="/mnt/BackLAN_POOL/LAN/weekly"

#'''''' Orígenes:
#cargar aqui usuario, server y/o rutas desde donde traer las cosas
campuslx='root@172.18.2.242:/'
anexolx='root@172.16.2.254:/'

########################################################
## Trabajar:
echo 'Inicio Semanal:'
echo '~~~~~~~~ MV ~~~~~~~~~~~~~~~~~'
$date
echo 'weekly.0 -> weekly.1 ->'
echo 'weekl.2 -> weekly.tmp -> weekly.0'
$mv "$dest_base".2/ "$dest_base".tmp
$mv "$dest_base".1/ "$dest_base".2
$mv "$dest_base".0/ "$dest_base".1
$mv "$dest_base".tmp/ "$dest_base".0
echo '~~~~~~~~~~~ CP ~~~~~~~~~~~~~~'
echo 'copiando con enlaces daily.0 => weekly.0'
$date
$cp -al /mnt/BackLAN_POOL/LAN/daily.0/. "$dest_base".0

echo '~~~~~~~~~~~ RSYNC ~~~~~~~~~~~~~~'
$date
echo "CAMPUSLX"
echo $rsync $campuslx "$dest_base".0/campuslx/ 
$rsync $campuslx "$dest_base".0/campuslx/ >> /mnt/BackLAN_POOL/snapshotG.log
$date
echo "ANEXOLX"
echo $rsync $anexolx "$dest_base".0/anexolx/
$rsync $anexolx "$dest_base".0/anexolx/ >> /mnt/BackLAN_POOL/snapshotG.log
echo "Fin rsync"; $date

echo '~~~~~~~~~~~ CHECK ~~~~~~~~~~~~~~'
#Archivo supuestamente invariable
#el inodo debe coincidir y debe tener mas de un link
#A menos que cambie alguna vez, claro está
echo "ANEXOLX:"
$stat "$dest_base".?/anexolx/root/archivo_de_control_invariable | grep Inode
echo
#Archivo que debería ser distinto cada día, al menos este debería copiarse en el rsync:
echo "$dest_base".0/anexolx/root/control.txt:; $cat "$dest_base".0/anexolx/root/control.txt
echo "$dest_base".1/anexolx/root/control.txt:; $cat "$dest_base".1/anexolx/root/control.txt
echo "$dest_base".2/anexolx/root/control.txt:; $cat "$dest_base".2/anexolx/root/control.txt
echo "$dest_base".3/anexolx/root/control.txt:; $cat "$dest_base".3/anexolx/root/control.txt
echo "$dest_base".4/anexolx/root/control.txt:; $cat "$dest_base".4/anexolx/root/control.txt
echo "$dest_base".5/anexolx/root/control.txt:; $cat "$dest_base".5/anexolx/root/control.txt
#                                                 FIN ##
########################################################
