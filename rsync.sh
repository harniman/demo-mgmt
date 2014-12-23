#!/bin/bash

# This script will differntially copy your JENKINS_HOME to a remote server
# using Rsync
#
# It performs a differential backup using hardlinks, saving each backup with a date/timestamp directory
#
#
#

SERVER=harniman.net
USER=harniman
DATA='/data'
TARGET='~/work'
timestamp=`date +"%Y-%m-%d-%H_%M_%S"`
inprogress='/data/backuplog/inprogress'
excludefile='excludes.txt'

while getopts s:o opt ; do
  case $opt in
  s)
      SERVER=$OPTARG
      ;;
  t)
      TARGET=$OPTARG
      ;;      
  u)
      USER=$OPTARG
      ;;
  esac
done

shift $((OPTIND - 1))

CMD=`echo $1 | tr '[:upper:]' '[:lower:]'`

function usage {
	echo "Usage $0 -s <servername> -o cmd " \
	where cmd is push or pull \
	-s is the server \
	-t is target directory \
	-u is the userid for the server
	
		
	exit
}

function dieonerror {
	exitcode=$?

	if [ $exitcode -ne $1 ] ; then
	
		echo ERROR: $2 : Exit code $exitcode
		exit 1
	fi
}

function doRsync {

		echo Performing full back up to $2
		rsync -Hav --delete --exclude-from $excludefile $1 $2
		dieonerror 0 "Error running rsync"
		
}

function doDiffRsync {
		echo Performing diff back up to $2, previous $3
		rsync -Hav --delete --exclude-from $excludefile $1 $2 --link-dest $3
		dieonerror 0 "Error running rsync"
}


case $CMD in
push)
	# Grab last backup
	mkdir -p /data/backuplog
	lastbackup=`ls -tr /data/backuplog | tail -1 | rev | cut -d' ' -f1 | rev`
	case $lastbackup in	
	'inprogress')	
		echo A backup is in progress and needs to be continued
		type=`cat $inprogress | cut -d':' -f1`
		timestamp=`cat $inprogress | cut -d':' -f2`
		lastbackup=`cat $inprogress | cut -d':' -f3`

		case $type in
		FULL)
			doRsync ${DATA} ${USER}@${SERVER}:${TARGET}/${timestamp}	
		;;
		
		PARTIAL)
			doDiffRsync ${DATA} ${USER}@${SERVER}:${TARGET}/${timestamp} ${TARGET}/${lastbackup}	
		;;
		
		*)
			echo unexpected previous backup type
			exit 2
		;;
		esac
	;;	
			

	'')
		echo No previous completed backup
		echo FULL:$timestamp >> $inprogress
		doRsync ${DATA} ${USER}@${SERVER}:${TARGET}/${timestamp}
		dieonerror 0 "Error running rsync"
	;;
	
	*)
	
		echo Last Backup was $lastbackup
		echo PARTIAL:$timestamp:$lastbackup >> $inprogress
		doDiffRsync ${DATA} ${USER}@${SERVER}:${TARGET}/${timestamp} ${TARGET}/${lastbackup}
		
	;;
	esac
	
	touch /data/backuplog/$timestamp
	rm  $inprogress

;;

pull)
	
;;

*)
	usage
;;
esac





