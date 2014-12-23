#!/bin/bash

echo stopping all containers


docker stop $(docker ps -a -q)

