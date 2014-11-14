#!/bin/sh
########################################################
## Configuración:
#''' Ejecutables:
cat="/usr/gnu/bin/cat"
mv="/usr/gnu/bin/mv -v"
cp="/usr/gnu/bin/cp -v"
echo="/usr/gnu/bin/echo"
stat="/usr/bin/stat"
rsync="/usr/bin/rsync --exclude --exclude 'tmp' --exclude '/dev/' --exclude=var/log -av --delete --numeric-ids --rsh=/usr/bin/ssh"

#'''''' Destinos:
dest_base="/ANEXOBCK/BACKUP/LAN/daily"

#'''''' Orígenes:
#cargar aquí usuario, server y/o rutas desde donde traer las cosas
campuslx='root@172.18.2.242:/'
anexolx= 'root@172.16.2.254:/'

########################################################
## Trabajar:
$echo '~~~~~~~~ MV ~~~~~~~~~~~~~~~~~'
$mv "$dest_base".5/ "$dest_base".tmp
$mv "$dest_base".4/ "$dest_base".5
$mv "$dest_base".3/ "$dest_base".4
$mv "$dest_base".2/ "$dest_base".3
$mv "$dest_base".1/ "$dest_base".2
$mv "$dest_base".0/ "$dest_base".1
$mv "$dest_base".tmp/ "$dest_base".0

$echo '~~~~~~~~~~~ CP ~~~~~~~~~~~~~~'
$cp -al "$dest_base".1/. "$dest_base".0

$echo '~~~~~~~~~~~ RSYNC ~~~~~~~~~~~~~~'
$rsync $campuslx "$dest_base".0/campuslx/
$rsync $anexolx "$dest_base".0/anexolx/

$echo '~~~~~~~~~~~ CHECK ~~~~~~~~~~~~~~'
#Archivo supuestamente invariable
#el inodo debe coincidir y debe tener mas de un link
$echo "ANEXOLX:"
stat "$dest_base".0/anexolx/root/archivo_de_control_invariable "$dest_base".0/anexolx/root/archivo_de_control_invariable "$dest_base".1/anexolx/root/archivo_de_control_invariable "$dest_base".2/anexolx/root/archivo_de_control_invariable "$dest_base".3/anexolx/root/archivo_de_control_invariable "$dest_base".4/anexolx/root/archivo_de_control_invariable "$dest_base".5/anexolx/root/archivo_de_control_invariable| grep Inode
$echo
#Archivo que debería ser distinto cada día, al menos este debería copiarse en el rsync:
$echo "$dest_base".0/anexolx/root/control.txt:; $cat "$dest_base".0/anexolx/root/control.txt:
$echo "$dest_base".1/anexolx/root/control.txt:; $cat "$dest_base".1/anexolx/root/control.txt:
$echo "$dest_base".2/anexolx/root/control.txt:; $cat "$dest_base".2/anexolx/root/control.txt:
$echo "$dest_base".3/anexolx/root/control.txt:; $cat "$dest_base".3/anexolx/root/control.txt:
$echo "$dest_base".4/anexolx/root/control.txt:; $cat "$dest_base".4/anexolx/root/control.txt:
$echo "$dest_base".5/anexolx/root/control.txt:; $cat "$dest_base".5/anexolx/root/control.txt:
#                                                 FIN ##
########################################################
