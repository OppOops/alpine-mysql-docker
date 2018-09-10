#!/bin/bash
TAG=local-mysql:dev
if [[ $UID != 0   ]]; then
     echo "Please run this script with sudo:"
     echo "sudo $0 $*"
     exit 1
fi
docker build -t $TAG .
