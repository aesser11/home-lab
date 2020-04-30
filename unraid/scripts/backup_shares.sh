#!/bin/bash
# Set variables
log_output="No stderr or stdout for this run"
single_return="
"
double_return="

"

# Do the backups -- send output to the console as well as capturing it
{ log_output=$(rsync -ah --stats /mnt/user/store /mnt/disks/easystore8tb/backups/store 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="$double_return"
{ log_output+=$(rsync -ah --stats /mnt/user/timemachine /mnt/disks/easystore8tb/backups/timemachine 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="$double_return"
{ log_output+=$(rsync -ah --stats /mnt/user/downloads /mnt/disks/easystore8tb/backups/downloads 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="$double_return"
{ log_output+=$(rsync -ah --stats /mnt/user/share /mnt/disks/easystore8tb/backups/share 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="$double_return"
#{ log_output+=$(rsync -ah --stats /mnt/user/media /mnt/disks/easystore8tb/backups/media 2>&1 | tee /dev/fd/5); } 5>&1 
#log_output+="$double_return"

# Unmount drive
{ log_output+=$(/sbin/umount '/dev/sdl1' 2>&1 | tee /dev/fd/5); } 5>&1 

# Send notification with result
/usr/local/emhttp/webGui/scripts/notify -e "Shares Backup" -s "Shares Backup Script Status" -d "backup_shares.sh finished running" -i "normal" -m "Log Output: $single_return$log_output"
