snapshotG - snapshots de gonzalo
=========
just read the raw version of this file
ES
--
(maybe english readme below, e também tal vez português lá baixo): estamos usando rsnapshot (http://www.rsnapshot.org/) para hacer backups incrementales, pero como tenemos mucha información, la etapa de borrado demora demasiado tiempo:
 [11/Nov/2014:01:45:02] echo 16401 > /var/run/rsnapshot.pid
 [11/Nov/2014:01:45:02] /usr/gnu/bin/rm -rf /BACKUP_POOL/BACKUP_FS/LAN/daily.6/
 [12/Nov/2014:12:12:25] mv /BACKUP_POOL/BACKUP_FS/LAN/daily.5/ /BACKUP_POOL/BACKUP_FS/LAN/daily.6/
...

Aproximadamente un día y medio borrando archivos antes de empezar el proceso de rsync. Además si todavía está funcionando el rsnapshot del día anterior, el del día actual no arranca, para no hacer conflicto. 
Una alternativa, para que al menos se copien los archivos es la opción:
   use_lazy_deletes        1

que borra cuando termina el backup, pero pueden ocurrir que se acumulen el borrado durante algunos días (haciendo todo mas lento)
 # ps ax | grep rm
   5316 ?        S 28:21 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.19075
  17767 ?        S  3:09 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.1244
  23563 ?        S 18:11 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.22682
  24327 ?        S 23:10 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.6214
  25507 ?        S  4:53 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.14736
  26648 ?        S 15:47 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.9109
  20396 pts/1    S  0:00 grep rm
   7595 pts/3    S 17:48 rm -rf /ANEXOBCK/BACKUP/LAN/_delete.14689

Otra vez: estamos hablando de MUCHA información.

Entonces, usando como base http://www.mikerubel.org/computers/rsync_snapshots/#Incremental y en particular la sugerencia de John Pelan (buscar "Update (2003.05.02): John Pelan"), se recicla el último directorio, de forma que borraría solo lo que no está mas. 
Y aparentemente funciona. Prestar mucha atención a la advertencia en el siguiente párrafo

EN
--
So, we where using rsnapshot (http://www.rsnapshot.org/) for incremental backups but we have a HUGE filesystem and the rm -rf stage take ages to finish:
 [11/Nov/2014:01:45:02] echo 16401 > /var/run/rsnapshot.pid
 [11/Nov/2014:01:45:02] /usr/gnu/bin/rm -rf /BACKUP_POOL/BACKUP_FS/LAN/daily.6/
 [12/Nov/2014:12:12:25] mv /BACKUP_POOL/BACKUP_FS/LAN/daily.5/ /BACKUP_POOL/BACKUP_FS/LAN/daily.6/

and sometimes the snapshot didn't even start because the previous one is still running. You can enable the use_lazy_deletes option, but in my case, this isn't really helping. After a few days, I have something like this:
 # ps ax | grep rm
   5316 ?        S 28:21 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.19075
  17767 ?        S  3:09 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.1244
  23563 ?        S 18:11 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.22682
  24327 ?        S 23:10 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.6214
  5507 ?        S  4:53 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.14736
  26648 ?        S 15:47 /usr/gnu/bin/rm -rf /ANEXOBCK/BACKUP/LAN/_delete.9109
  20396 pts/1    S  0:00 grep rm
  7595 pts/3    S 17:48 rm -rf /ANEXOBCK/BACKUP/LAN/_delete.14689
Again: I have a HUGE amount of data.

So, after read this: http://www.mikerubel.org/computers/rsync_snapshots I'm about to work with the suggestion made by John Pelan and recyle the last directory. 

It seems to work for me™, but take care of the warning in the same document. 

PT
--
Ainda tenho que escrever o LEA-ME
