#!/bin/bash
# Set variables
logdate=$(date +%F)
scriptdir=/boot/config/plugins/user.scripts/scripts/backup_shares

# Do the backups
rsync -avhiP --stats --log-file=$scriptdir/$logdate.log /mnt/user/downloads /mnt/disks/easystore8tb/backups/downloads
rsync -avhiP --stats --log-file=$scriptdir/$logdate.log /mnt/user/media /mnt/disks/easystore8tb/backups/media
rsync -avhiP --stats --log-file=$scriptdir/$logdate.log /mnt/user/share /mnt/disks/easystore8tb/backups/share
rsync -avhiP --stats --log-file=$scriptdir/$logdate.log /mnt/user/store /mnt/disks/easystore8tb/backups/store
rsync -avhiP --stats --log-file=$scriptdir/$logdate.log /mnt/user/timemachine /mnt/disks/easystore8tb/backups/timemachine

# Send notification with result
# -m "Result $result"
/usr/local/emhttp/webGui/scripts/notify -e "Unraid Server Notice" -s "Unassigned Devices" -d "Backup script finished" -i "normal"
