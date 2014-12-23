demo-mgmt
=========

A management container.

Provides a series of scripts and utilities to support the test environment:

Utilities:
----------

* git
* telnet
* curl
* tcpdump

	
Scripts:
--------

##stop.sh
Stops ALL the docker containers

Usage:

	./stop.sh

##start.sh
Starts the containers in the required order:

* storage 
* skydns 
* skydock 
* joc-1 
* joc-2 
* api-team-1 
* api-team-2 
* web-team-1 
* web-team-2 
* slave-1 
* slave-2 
* mgmt

At the end it starts the *proxy* container and launches a new TTY with a bash shell ready to start *haproxy*. 


Usage:
	
	./start.sh
	
	<once the proxy docker container is launched>
	
	service rsyslog start
	service haproxy start
	
	
##Rsync

Provides a mechanism to perform a differential backup of the */data* directory to a remote server running rsync. This could be an rsync daemon on the host computer, an external NAS or even a secure hosting site.

Each run creates a timestamped directory within the target folder in the format: `YY-MM-DD-HH_MM_SS`.

The initial run will take some time and perform a full backup. There is an exclude list that can be managed - see `excludes.txt`.

Subsequent runs use the rsync **link-dest=** setting to only upload new or changed content. Hardlinks are used such that when viewing the timestamped directory all files visible. As old directores are deleted, the physical file remains until there are o further hardlink references to it.

**Think Apple Time Machine Backup** 

The process also maintains a local reference of the backup in progress and the previous timestamps. Should an rsync fail, re-running will derive the previous command and re-execute it.

Usage:

	./rsync -s <target host> -t <target host directory> -u <userid>
	


