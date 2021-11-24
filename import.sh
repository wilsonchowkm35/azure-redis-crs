#!/bin/bash

importFromBlob() {

	BLOB_URL=$1
	NAME=$2
	RESOURCE_GROUP=$3
	SUBSCRIPTION=$4

	IMPORT_OUTPUT=$(az redis import \
		--output \
		--files ${BLOB_URL} \
		--name ${NAME} \
		--resource-group ${RESOURCE_GROUP} \
		--subscription ${SUBSCRIPTION})
}

main() {

	CONFIG=`./load-config.sh ${1}`
	declare ${CONFIG}

	# getSASToken ${SOURCE_TYPE} ${SOURCE_ACC} ${SOURCE_CONTAINER} ${SOURCE_BLOB} 

	DEST_TOKEN=$(cat ./dest-sas)
	
	# Append sas token to dest blob url
	DEST_BLOB="${DEST_BLOB}?${DEST_TOKEN}"

	DEST_BLOB_URL="${DEST_BLOB_URL}${DEST_TOKEN}"

	importFromBlob ${DEST_BLOB_URL} ${DEST_NAME} ${DEST_RESOURCE_GROUP} ${DEST_SUBSCRIPTION}

}

if [ "${1}" != "--source-only" ]; then
	echo "Start processing..."
  main "${@}"
fi

