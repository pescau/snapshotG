#!/bin/sh
########################################################################
### Calesita Cuantica v1.5                                          ####
### snapshotG v0.9 Gonzalo Rivero. Ideas tomadas de rsnapshot
### snapshotG v1.0 Gonzal Rivero. Agregados archivos de control
### snapshotR v1.5 Facundo Russo. Simplificado y unido en un solo script
########################################################################
#export LC_ALL=C

dest_base=/BackLAN/CALESITA

## Configuracion
#Ejecutables:
cat="/usr/gnu/bin/cat"
mv="/usr/gnu/bin/mv"
cp="/usr/gnu/bin/cp"
mkdir="/usr/gnu/bin/mkdir"
rm="/usr/gnu/bin/rm"
#echo="/usr/gnu/bin/echo"
stat="/usr/bin/stat"
date="/usr/gnu/bin/date"
rsyncargs="-aHv --delete --numeric-ids --delete-excluded --exclude-from=$dest_base/rsync_exclude_default"
rsync="/usr/bin/rsync $rsyncargs"

#Ver si se ejecuta (no es primero ni domingo), o que:
ndia=`date "+%a"`

modo="daily"
modoret=6

if [ $ndia == "Sun" ]
then
    modo="weekly"
    modoret=3
fi

ddia=`date "+%d"`
if [ $ddia = "01" ]
then
    modo="monthly"
    modoret=2
fi
echo "ndia:$ndia ddia:$ddia" 

#'''''' Destinos:
dest_daily=$dest_base/daily
dest_weekly=$dest_base/weekly
dest_monthly=$dest_base/monthly
dest_logs=$dest_base/../

#Crear el directorio inicial si es que no existe
if [ ! -d "$dest_daily".0 ]
then
    mkdir "$dest_daily".0
fi

#'''''' Orígenes:
#cargar aqui usuario, server y/o rutas desde donde traer las cosas
servers=(
[campuslx]="root@172.18.2.242:/"
[anexolx]="root@172.17.2.254:/"
[wl12prod]="root@172.16.250.62:/"
[central]="root@172.17.2.229:/"
[oraapex]="root@172.16.250.61:/"
[haproxy]="root@200.10.180.156:/"
[notas]="root@200.10.180.134:/usr/local/www/apache22/data/notas/"
[wwwdesa]="root@www-desa.ucasal.edu.ar:/"
[www]="root@www.ucasal.edu.ar:/"
[logger]="root@logger.ucasal.edu.ar:/"
[dnsa]="root@200.10.180.130:/"
[dnsb]="root@:200.10.181.2:/"
[oraprod]="--exclude /u01/app/oracle/oradata/ root@oraprod:/"
)

########################################################
## Trabajar:
echo "Inicio $modo:"
echo '~~~~~~~~ MV ~~~~~~~~~~~~~~~~~'
$date

#ascii art cortesia de gonza
for i in {0..$modoret}
do
    if ! ((i % 3))
    then
	echo
    fi
    if [ "$i" -ne "$modoret" ]
    then
	printf "$modo"."$i"" -> "
    else
	printf "$modo"."tmp -> "$modo.0
    fi
done
echo

for i in $(seq $modoret -1 0)
do
    num=$i
    prevnum=$(($i -1))
    if [ "$i" -eq "$modoret" ]
    then
	num=tmp
    fi
    if [ "$i" -eq 0 ]
    then
	prevnum=tmp
    fi
    $mv "$dest_base"/$modo.$prevnum/ "$dest_base"/$modo.$num
done

echo "------------fin mv----------"

echo '~~~~~~~~~~~ CP ~~~~~~~~~~~~~~'
case $modo in
    daily)
	echo 'copiando con enlaces daily.1 => daily.0'
	$date
	$cp -al $dest_daily.1/. $dest_daily.0/ 2> $dest_logs/cp.log
	;;
    weekly)
	echo 'copiando con enlaces daily.0 => weekly.0'
	$date
	$cp -al $dest_daily.0/. $dest_weekly.0 2> $dest_logs/cp.log
	;;
    monthly)
	echo 'copiando con enlaces daily.0 => monthly.0'
	$date
	$cp -al $dest_daily.0/. $dest_monthly.0 2> $dest_logs/cp.log
	;;
esac
echo "fin copia" ; $date

echo '~~~~~~~~~~~ RSYNC ~~~~~~~~~~~~~~'
$date
for server in "${!servers[@]}"
do
    echo "server = $server"
    $rsync ${servers[$server]} "$dest_base"/"$modo".0/$server/ 2>&1 1>$dest_logs/rsync-$server-$modo.log
    echo "" ; $date; echo ""
done
echo "Fin rsync"; $date


echo '~~~~~~~~~~~ CHECK ~~~~~~~~~~~~~~'
#Archivo supuestamente invariable
#el inodo debe coincidir y debe tener mas de un link
echo "ANEXOLX:"
$stat "$dest_base"/"$modo".?/anexolx/root/archivo_de_control_invariable | grep Inode
echo

#Archivo que debería ser distinto cada día, al menos este debería copiarse en el rsync:
for i in {0..$(($modoret -1))}
do
    echo "$dest_base"/$modo.$i/anexolx/root/control.txt:; $cat "$dest_base"/$modo.$i/anexolx/root/control.txt
done

case $modo in
    weekly)
	echo '~~~~~~~~~ LIMPIANDO ~~~~~~~~~~~~'
	echo 'Dejar el daily.5 en blanco para que mañana empiece con un directorio limpio'
	$mv $dest_daily.5 $dest_daily.6
	$mkdir $dest_daily.5
	$rm -rf $dest_daily.6
	echo "Fin de limpieza: "; $date
	;;
    monthly)
	echo '~~~~~~~~~ LIMPIANDO ~~~~~~~~~~~~'
	echo 'Dejar el weekly.2 en blanco para que el domingo empiece con un directorio limpio'
	$mv $dest_weekly.2 $dest_weekly.3
	$mkdir $dest_weekly.2
	$rm -rf $dest_weekly.3
	echo "Fin de limpieza: "; $date
	;;
esac


#                                                 FIN ##
########################################################
