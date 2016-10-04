# Tiddlywiki-Backup-Script

# 4th Oct 2016	AFN

# anbackup.sh	is the new version of the backup script previously written for my Tiddlywiki files.
# 
# Where it previously only took one file, monitored it and backed it up it can now using the -d flag 
# backup all the .html files in a directory to the /Backup folder.

#	arguments	-d <directory>
#								monitor and backup all *.html files in the directory. File will be backed
#								up to the directory they're currently in with /Backup/appended to the end.
#
#					-t <time in seconds>
#								period in seconds between checking the files to see which need to be backed up
#
#					-f <file to be backed up> <backup filename and location>
#
# Some more testing is required but it appears fairly robust. Known items to be fixed are:
#
# 1) command line arguments need to be better checked
# 2) if the source directory in -d mode does not have a trailing '/' it fails
# 3) add a version reporting option (-v?)