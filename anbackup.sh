#!/bin/sh
#	anbackup.sh	 a script to continually backup files that might become corrupted
#						originally for Tiddlywiki files that can when open be completely lost.
#
#  Version		1.0
#
#	arguments	-d <directory>
#								monitor and backup all *.html files in the directory. File will be backed
#								up to the directory they're currently in with /Backup/appended to the end.
#
#					-t <time in seconds>
#								period in seconds between checking the files to see which need to be backed up
#
#					-f <file to be backed up> <backup filename and location>
#
##################################################################################################

	# Parse command line options

sleep_time=10		# Will be written over if -t argument is set

while [ "$#" -gt 0 ]; do
  case "$1" in
    -d) directory_name="$2"; shift 2;;		# Need to test each option for a following parameter
    -f) original_file="$2"; backup_file="$3"; shift 3;;
    -t) sleep_time="$2"; shift 2;;

    -*) echo "unknown option: $1" >&2; exit 1;;
    *) echo "unknown argument $1 terminating"
		echo; echo "  USAGE: anbackup -d <directory to backup> -f <original file> <backup file> -t <period between checks>"; exit 1;;
  esac
done

	# test command line options to ensure they are sensible
	# check that -d and -f options aren't being used together

if [ $directory_name ] && [ $original_file ]
   then echo "cannot use -d and -f options together"
	exit 1
fi

	# check that one of the options is selected

if [ ! $directory_name ] && [ ! $original_file ]
   then echo "need one of -d or -f options"
	exit 1
fi

	# check that if -t has been used "period" contains a sensible number
	# TO BE ADDED

	# check that file to be backed up exists
	# TO BE ADDED

	# check that directories exist for to and from backup
	# TO BE ADDED

if  [ $original_file ]; then		# If from file to file

	echo "original file = $original_file"
	echo "backup file = $backup_file"
	echo

	if [ ! -e "$original_file" ]
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

else		# Directory backup

	# Do I need shopt -s nullglob

	file_list=("$directory_name"*.html)     # get list of all current .html files in the directory

	echo
	echo Number of files found for backup monitoring ${#file_list[@]}
	
	echo
	echo "Filenames:"
	for i in "${file_list[@]}"; do
      echo -e "\t$i"						#NOTE: -e enables backslash escaped characters in echo
   done
	
		# create backup filenames
	
	file_count=${#file_list[@]}
	count=0
	while [[ count -lt file_count ]]; do
		backup_list[count]=$(dirname "${file_list[0]}")/Backup/$(basename "${file_list[count]}")	
		((count++))
	done
	
#	echo "Backup Filenames:"
#	for i in "${backup_list[@]}"; do
#     echo -e "\t$i"						#NOTE: -e enables backslash escaped characters in echo
#   done

		# If file does not exist in Backup directory copy it there.
		
	count=0
	while [[ count -lt file_count ]]; do		# could this be done as a for i in "${file_list[@]}"; do ?
		if [ ! -e "${backup_list[count]}" ]; then
			echo "Creating backup file" ${backup_list[count]}
			cp -p "${file_list[count]}" "${backup_list[count]}"	#write file to be backed up to new location
		fi
		((count++))
	done
	
	while true; do

	count=0

		while [[ count -lt file_count ]]; do
		
				# Check each file and backup if it's changed
			if [ "${file_list[count]}" -nt "${backup_list[count]}" ]; then
				echo
				echo -n $(date +"%T -  ")
				
				if [ -s "${file_list[count]}" ]    # and the file isn't empty
				then
					cp -p "${file_list[count]}" "${backup_list[count]}"	#replace the backup with the changed file
					echo "backed up ${file_list[count]}"
				else
					echo WARNING original file ${file_list[count]} is empty!
					echo press return to copy last backup to original location.
					
					read text
					cp -p "${backup_list[count]}" "${file_list[count]}" 
					echo "copied ${backup_list[count]} to ${file_list[count]}"
					
				fi
				
			fi 
		
		((count++))
		
		done

		echo -n "."	
		sleep $sleep_time

	done
		
		
#   done
	
	exit
fi