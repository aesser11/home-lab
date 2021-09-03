#!/bin/bash
#arrayStarted=true

# excluded shares - backups for these shares will be manual
# /mnt/user/media/movies /mnt/disks/easystore8tb/backups/media/movies
# /mnt/user/media/tv /mnt/disks/easystore8tb/backups/media/tv

logdate="$(date +%F)"
logdir="/boot/config/plugins/user.scripts/scripts/backup_shares/logs"
#$isoscode
#$vdiskcode
#$downloadscode
#$musiccode
#$sharecode
#$storecode
#$timemachinecode
#$umountcode

#rsync -ahP --log-file=$logdir/apps-vms-isos-$logdate.log /mnt/user/apps/vms/isos /mnt/disks/easystore8tb/backups/apps/vms
#isoscode="$?"
#rsync -ahP --log-file=$logdir/apps-vms-vdisk-$logdate.log /mnt/user/apps/vms/vdisk /mnt/disks/easystore8tb/backups/apps/vms
#vdiskcode="$?"
rsync -ahP --log-file=$logdir/downloads-$logdate.log /mnt/user/downloads /mnt/disks/easystore8tb/backups
downloadscode="$?"
rsync -ahP --log-file=$logdir/media-music-$logdate.log /mnt/user/media/music /mnt/disks/easystore8tb/backups/media
musiccode="$?"
rsync -ahP --log-file=$logdir/share-$logdate.log /mnt/user/share /mnt/disks/easystore8tb/backups
sharecode="$?"
rsync -ahP --log-file=$logdir/store-$logdate.log /mnt/user/store /mnt/disks/easystore8tb/backups
storecode="$?"
rsync -ahP --log-file=$logdir/timemachine-$logdate.log /mnt/user/timemachine /mnt/disks/easystore8tb/backups
timemachinecode="$?"

# unmount drive
#/sbin/umount -v '/dev/sdl1'
#umountcode="$?"

# error notification handling
# [[ "$isoscode" -eq "0" ]] && [[ "$vdiskcode" -eq "0" ]] && 
# /apps/vms/isos/ = $isoscode
# /apps/vms/vdisk/ = $vdiskcode
# umount
#umount /dev/sdl1 = $umountcode

#0 	success
#1 	incorrect invocation or permissions
#2 	system error (out of memory, cannot fork, no more loop devices)
#4 	internal mount bug
#8 	user interrupt
#16	problems writing or locking /etc/mtab
#32	mount failure
#64	some mount succeeded

if [[ "$downloadscode" -eq "0" ]] && [[ "$musiccode" -eq "0" ]] && [[ "$sharecode" -eq "0" ]] && [[ "$storecode" -eq "0" ]] && [[ "$timemachinecode" -eq "0" ]]
then 
	/usr/local/emhttp/webGui/scripts/notify -e "Shares Backup" -s "Shares Backup Script" -d "backup_shares.sh completed successfully" -i "normal" -m "Log Directory: 
$logdir

Exit Codes:
# rsync
/downloads/ = $downloadscode
/media/music/ = $musiccode
/share/ = $sharecode
/store/ = $storecode
/timemachine/ = $timemachinecode
"
else
	/usr/local/emhttp/webGui/scripts/notify -e "Shares Backup" -s "Shares Backup Script" -d "backup_shares.sh completed with errors" -i "alert" -m "Log Directory: 
$logdir

Exit Codes:
# rsync
/downloads/ = $downloadscode
/media/music/ = $musiccode
/share/ = $sharecode
/store/ = $storecode
/timemachine/ = $timemachinecode

Exit Code References:
# rsync
0 	Success
1 	Syntax or usage error
2 	Protocol incompatibility
3 	Errors selecting input/output files, dirs
4 	Requested  action not supported: an attempt was made to manipulate 64-bit files on a platform that cannot support them; or an option was specified that is supported by the client and not by the server.
5 	Error starting client-server protocol
6 	Daemon unable to append to log-file
10	Error in socket I/O
11	Error in file I/O
12	Error in rsync protocol data stream
13	Errors with program diagnostics
14	Error in IPC code
20	Received SIGUSR1 or SIGINT
21	Some error returned by waitpid()
22	Error allocating core memory buffers
23	Partial transfer due to error
24	Partial transfer due to vanished source files
25	The --max-delete limit stopped deletions
30	Timeout in data send/receive
35	Timeout waiting for daemon connection
"
fi