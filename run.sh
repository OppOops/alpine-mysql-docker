#!/bin/bash
TAG=local-mysql:dev
LOCAL_DEP=$PWD/deploy
HOST_DIST=$PWD/runtime
HOST_PORT=34758
CONTAINER_NAME=local-mysql-dev
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi
mkdir -p $HOST_DIST
if [ -z "$(ls -A $HOST_DIST)" ]; then
    cp -r $LOCAL_DEP $HOST_DIST
fi
docker run -d -v $HOST_DIST:/app -p $HOST_PORT:3306 --name $CONTAINER_NAME  $TAG
