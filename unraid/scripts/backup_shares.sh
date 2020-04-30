#!/bin/bash
# Set variables
error_output="No errors for this run"
summary_output="No summary for this run"

# Do the backups -- fix stderr and stdout commands
rsync -ah --stats /mnt/user/store /mnt/disks/easystore8tb/backups/store 2> "$error_output" 1> "$summary_output"
rsync -ah --stats /mnt/user/timemachine /mnt/disks/easystore8tb/backups/timemachine 2>> "$error_output" 1>> "$summary_output"
rsync -ah --stats /mnt/user/downloads /mnt/disks/easystore8tb/backups/downloads 2>> "$error_output" 1>> "$summary_output"
rsync -ah --stats /mnt/user/share /mnt/disks/easystore8tb/backups/share 2>> "$error_output" 1>> "$summary_output"
#rsync -ah --stats /mnt/user/media /mnt/disks/easystore8tb/backups/media 2>> "$error_output" 1>> "$summary_output"

# Unmount drive
/sbin/umount '/dev/sdl1' 2>> "$error_output" 1>> "$summary_output"

# Send notification with result
/usr/local/emhttp/webGui/scripts/notify -e "Share Backup" -s "shareData Backup" -d "Backup of shareData complete" -i "normal" -m "Error output: $error_output <br><br> <hr> <br> Summary output: $summary_output"
