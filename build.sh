#!/bin/bash


USER="harniman"
REPOSITORY_NAME="demo-mgmt"
VERSION=""

IMAGE_NAME="$USER/$REPOSITORY_NAME"

if [ "$VERSION"  ]; then
	IMAGE_NAME+=":$VERSION"
fi

echo Building docker file $IMAGE_NAME



docker build -t="$IMAGE_NAME" .

docker push $IMAGE_NAME
