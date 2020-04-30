#!/bin/bash
# Set variables
logdate=$(date +%F)
logdir=/boot/config/plugins/user.scripts/scripts/backup_shares/logs
error_output="No errors for this run"

# Do the backups
rsync -avhi --stats --log-file=$logdir/downloads-$logdate.log /mnt/user/downloads /mnt/disks/easystore8tb/backups/downloads 2> "$error_output"
#rsync -avhi --stats --log-file=$scriptdir/$logdate.log /mnt/user/media /mnt/disks/easystore8tb/backups/media 2> "$error_output"
rsync -avhi --stats --log-file=$logdir/backups-$logdate.log /mnt/user/share /mnt/disks/easystore8tb/backups/share 2> "$error_output"
rsync -avhi --stats --log-file=$logdir/store-$logdate.log /mnt/user/store /mnt/disks/easystore8tb/backups/store 2> "$error_output"
rsync -avhi --stats --log-file=$logdir/timemachine-$logdate.log /mnt/user/timemachine /mnt/disks/easystore8tb/backups/timemachine 2> "$error_output"

# Send notification with result
/usr/local/emhttp/webGui/scripts/notify -e "Unraid Backup Notice" -s "Backup Script Status" -d "Backup script finished" -i "normal" -m "Error output: $error_output"

# Unmount drive -- does this unmount any drive in this slot or will the external always be considered sdl1? -- does this spin down the drive as well?
/sbin/umount '/dev/sdl1' 2>&1
