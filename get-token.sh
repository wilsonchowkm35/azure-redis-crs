#!/bin/bash

getSASToken() {
	TYPE=$1
	ACCOUNT=$2
	CONTAINER=$3
	BLOB=$4

	EXP=$(date -v +1d '+%Y-%m-%d')

	SAS_TOKEN=`az storage ${TYPE} generate-sas \
    --account-name ${ACCOUNT} \
    --name ${CONTAINER} \
    --permissions acdlrw \
    --expiry ${EXP} \
    --auth-mode login \
    --as-user`

	echo ${SAS_TOKEN} | sed 's/"//g'
}

if [ "${1}" != "--source-only" ]; then
    getSASToken "${@}"
fi

