#!/bin/bash
# Set variables
log_output="No stderr or stdout for this run"

# Do the backups
rsync -ah --stats /mnt/user/store /mnt/disks/easystore8tb/backups/store 2>&1 > "$log_output"
rsync -ah --stats /mnt/user/timemachine /mnt/disks/easystore8tb/backups/timemachine 2>&1 >> "$log_output"
rsync -ah --stats /mnt/user/downloads /mnt/disks/easystore8tb/backups/downloads 2>&1 >> "$log_output"
rsync -ah --stats /mnt/user/share /mnt/disks/easystore8tb/backups/share 2>&1 >> "$log_output"
#rsync -ah --stats /mnt/user/media /mnt/disks/easystore8tb/backups/media 2>&1 >> "$log_output"

# Unmount drive
/sbin/umount '/dev/sdl1' 2>&1 >> "$log_output"

# Send notification with result
/usr/local/emhttp/webGui/scripts/notify -e "Share Backup" -s "shareData Backup" -d "Backup of shareData complete" -i "normal" -m "Log output: $log_output"
