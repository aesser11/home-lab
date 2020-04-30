#!/bin/bash
# Excluded shares
# /mnt/user/media /mnt/disks/easystore8tb/backups/media

# Set variables
log_output="No stderr or stdout for this run"

# Do the backups
log_output="
###############
/mnt/user/store
###############
"
{ log_output+=$(rsync -ah --stats /mnt/user/store /mnt/disks/easystore8tb/backups/store 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="

###############
/mnt/user/timemachine
###############
"
{ log_output+=$(rsync -ah --stats /mnt/user/timemachine /mnt/disks/easystore8tb/backups/timemachine 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="

###############
/mnt/user/downloads
###############
"
{ log_output+=$(rsync -ah --stats /mnt/user/downloads /mnt/disks/easystore8tb/backups/downloads 2>&1 | tee /dev/fd/5); } 5>&1 
log_output+="

###############
/mnt/user/share
###############
"
{ log_output+=$(rsync -ah --stats /mnt/user/share /mnt/disks/easystore8tb/backups/share 2>&1 | tee /dev/fd/5); } 5>&1 

# Unmount drive
log_output+="

##########################
Unmount drive at /dev/sdl1
##########################
"
{ log_output+=$(/sbin/umount -v '/dev/sdl1' 2>&1 | tee /dev/fd/5); } 5>&1 

# Send notification with result
/usr/local/emhttp/webGui/scripts/notify -e "Shares Backup" -s "Shares Backup Script Status" -d "backup_shares.sh finished running" -i "normal" -m "Log Output: $log_output"
