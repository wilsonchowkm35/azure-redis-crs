#!/bin/bash

copyCrossRegion() {

	SOURCE_BLOB=$1
	DEST_BLOB=$2

	if [ -z "${SOURCE_BLOB}" ] || [ -z "${DEST_BLOB}" ]; then
		echo "Missing source or destination blob url"
		exit
	fi

	COPY_OUTPUT=$(./azcopy/azcopy copy \
		--output-type \
		${SOURCE_BLOB} \
		${DEST_BLOB})
	
	echo ${COPY_OUTPUT}
}

main() {

	CONFIG=`./load-config.sh ${1}`
	declare ${CONFIG}

	SOURCE_TOKEN=`./get-token.sh ${SOURCE_BLOB_TYPE} ${SOURCE_BLOB_STORAGE_ACC} ${SOURCE_BLOB_CONTAINER}`
	# echo ${SOURCE_TOKEN} > ./source.token

	SOURCE_BLOB_URL="${SOURCE_BLOB_URL}?${SOURCE_TOKEN}"
	
	DEST_TOKEN=`./get-token.sh ${DEST_BLOB_TYPE} ${DEST_BLOB_STORAGE_ACC} ${DEST_BLOB_CONTAINER}`

	DEST_BLOB_URL="${DEST_BLOB_URL}?${DEST_TOKEN}"
	
	RESP=`copyCrossRegion ${SOURCE_BLOB_URL} ${DEST_BLOB_URL}`

	echo "Cross region copy result: ${RESP}"

}

