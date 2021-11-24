#!/bin/bash

copyCrossRegion() {

	SOURCE_BLOB=$1
	DEST_BLOB=$2

	if [ -z "${SOURCE_BLOB}" ] || [ -z "${DEST_BLOB}" ]; then
		echo "Missing source or destination blob url"
		exit
	fi

	echo "SOURCE $1 DEST $2"

	COPY_OUTPUT=$(./bin/azcopy copy \
		${SOURCE_BLOB} \
		${DEST_BLOB} \
		--recursive)
	
	echo ${COPY_OUTPUT}
}

main() {

	CONFIG=`./load-config.sh ${1}`
	declare ${CONFIG}

	# login to source account
	# ./login.sh ${1} source 

	# SOURCE_TOKEN=`./get-token.sh ${SOURCE_BLOB_TYPE} ${SOURCE_BLOB_STORAGE_ACC} ${SOURCE_BLOB_CONTAINER}`
	SOURCE_TOKEN=`cat ./source-sas`

	SOURCE_BLOB_URL="${SOURCE_BLOB_URL}${SOURCE_TOKEN}"

	echo "get token for destination"

	# ./login.sh ${1} dest

	# DEST_TOKEN=`./get-token.sh ${DEST_BLOB_TYPE} ${DEST_BLOB_STORAGE_ACC} ${DEST_BLOB_CONTAINER}`
	DEST_TOKEN=`cat ./dest-sas`

	if [ -z "${DEST_TOKEN}" ]; then
		echo "Token Authenication Error!"
		exit
	fi

	DEST_BLOB_URL="${DEST_BLOB_URL}${DEST_TOKEN}"
	
	echo "copying file from ${SOURCE_BLOB_URL} to ${DEST_BLOB_URL}"

	RESP=`copyCrossRegion ${SOURCE_BLOB_URL} ${DEST_BLOB_URL}`

	echo "Cross region copy result: ${RESP}"

}

if [ "${1}" != "--source-only" ]; then
	echo "Start processing..."
  main "${@}"
fi

