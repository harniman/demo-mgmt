#!/bin/bash

echo starting the docker containers

CONTAINERS="storage skydns skydock joc-1 joc-2 api-team-1 api-team-2 web-team-1 web-team-2 slave-1 slave-2 mgmt"

for server in $CONTAINERS
do

echo starting $server
docker start $server

done

docker start proxy

docker exec -it proxy bash

