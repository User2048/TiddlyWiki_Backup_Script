#!/bin/sh
echo $# arguments

if [ $# -lt 2 ] || [ $# -gt 3 ]; 
    then echo "Usage: backup_monitor <original file> <backup_file> <sleep time (secs)>"
	exit
fi
	
original_file=$1
backup_file=$2

declare -i sleep_time

if [ $# -eq 3 ]
then
   sleep_time=$3
else
   sleep_time=10
fi

echo "original file = $original_file"
echo "backup file = $backup_file"
echo

if [ ! -e "$backup_file" ]
then
   echo "Creating backup file"
	echo
   cp -p "$original_file" "$backup_file"	#write file to be backed up to new location
fi

while true;
do

	if [ "$original_file" -nt "$backup_file" ]   # If the file to be backed up has changed since the last backup
	then
		echo
		echo -n $(date +"%T -  ")
		
		if [ -s "$original_file" ]    # and the file isn't empty
		then
			cp -p "$original_file" "$backup_file"	#replace the backup with the changed file
			echo "backed up $original_file"
		else
			echo WARNING original file is empty!
			echo If you wish to copy last backup to original location type Y
			
			read text
			if [ $text == 'Y' ]
			then
			   cp -p "$backup_file" "$original_file"
				echo "copied $backup_file to $original_file"
		   fi
			
		fi
		
	else
		echo -n "."
	fi

   sleep $sleep_time
	
done
