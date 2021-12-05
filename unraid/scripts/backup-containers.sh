#!/bin/bash
source="/mnt/user/apps/docker/appdata/minecraft4"
destination="/mnt/user/apps/docker/appdata/backups"

while [ "true" ];
do
	datetime="$(date +%Y-%m-%d-%s)"
	name="minecraft4-$datetime"
	alive=`docker inspect -f '{{.State.Running}}' minecraftjava4`

	if [[ $alive == "true" ]]
	then
		# backup
		zip -r "$destination/$name.zip" "$source"
		printf "done with the archival of $name.zip from $source to $destination"
	else 
		printf "no backup taken, docker is not running, variable state is $alive"
	fi

	# wait
	printf "sleeping for 1 hr"
	sleep 3600
done