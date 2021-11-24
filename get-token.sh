#!/bin/bash

getSASToken() {
	TYPE=$1
	ACCOUNT=$2
	CONTAINER=$3
	BLOB=$4

	EXP=$(date -v +1d '+%Y-%m-%d')

	echo $TYPE
	echo $ACCOUNT
	echo $CONTAINER

	SAS_TOKEN=`az storage ${TYPE} generate-sas \
    --account-name ${ACCOUNT} \
    --name ${CONTAINER} \
    --permissions acdrw \
    --expiry ${EXP} \
    --auth-mode login \
    --as-user`

		# --full-uri`
    # --container-name ${CONTAINER} \
	
	echo ${SAS_TOKEN}
}

if [ "${1}" != "--source-only" ]; then
    getSASToken "${@}"
fi

