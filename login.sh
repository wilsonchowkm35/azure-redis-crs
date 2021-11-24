#!/bin/sh

if [ -z "$1" ]; then
	echo "Missing configuration"
	exit
fi

CONFIG=$(./bin/parseYaml.sh "${1}" | sed 's/"//g')

declare ${CONFIG}

TOKEN=`./get-token.sh ${SOURCE_BLOB_TYPE} ${SOURCE_BLOB_STORAGE_ACC} ${SOURCE_BLOB_CONTAINER}`

az login --tenant 6bc0fbe1-6d12-4aa0-bbeb-e4befd97a90c
# az login --use-device-code --tenant 6bc0fbe1-6d12-4aa0-bbeb-e4befd97a90c

