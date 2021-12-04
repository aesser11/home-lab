#!/bin/bash
datetime="$(date +%Y-%m-%d-%s)"
source="/mnt/user/apps/docker/appdata/minecraft4"
alive=`docker inspect -f '{{.State.Running}}' minecraftjava4`
destination="/mnt/user/apps/docker/appdata/backups"
name="minecraft4-$datetime"

# don't do backups if the container isn't running
while [ "$alive" == "true" ];
do
	# backup
	zip -r "$destination/$name.zip" "$source"
	# wait
	printf "done with the archival of $name.zip from $source to $destination, sleeping for 5 minutes"
	sleep 300
done