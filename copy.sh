#!/bin/bash

exportRedis() {
	CONTAINER=$1
	PREFIX=$2
	NAME=$3
	RESOURCE_GROUP=$4
	SUBSCRIPTION=$5

	if [ -z "${CONTAINER}" ] || [ -z "${PREFIX}" ] || [ -z "${NAME} "] || [ -z "${RESOURCE_GROUP}" ] || [ -z "${SUBSCRIPTION}" ]; then
		echo "Missing arguments"
		exit
	fi

	EXPORT_OUTPUT=$(az redis export \
		--output \
		--container ${CONTAINER} \
		--prefix ${PREFIX} \
		--name ${NAME} \
		--resource-group ${RESOURCE_GROUP} \
		--subscription ${SUBSCRIPTION})

}

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
}

getSASToken() {
	TYPE=$1
	ACCOUNT=$2
	CONTAINER=$3
	BLOB=$4

	EXP=$(date -v +10d '+%Y%m%d')

	SAS_TOKEN=$(az storage ${TYPE} generate-sas \
    --account-name ${ACCOUNT} \
    --container-name ${CONTAINER} \
    --name ${BLOB} \
    --permissions acdrw \
    --expiry ${EXP} \
    --auth-mode login \
    --as-user \
		--full-uri)

}

main() {
	if [ -z "$1" ]; then
		echo "Missing configuration"
		exit
	fi

	source ${1}

	getSASToken ${SOURCE_TYPE} ${SOURCE_ACC} ${SOURCE_CONTAINER} ${SOURCE_BLOB} 
	
	# Append sas token to source blob url
	SOURCE_BLOB="${SOURCE_BLOB}?${SAS_TOKEN}"

	exportRedis ${SOURCE_CONTAINER} ${SOURCE_PREFIX} ${SOURCE_NAME} ${SOURCE_RESOURCE_GROUP} ${SOURCE_SUBSCRIPTION} 

	getSASToken ${DEST_TYPE} ${DEST_ACC} ${DEST_CONTAINER} ${DEST_BLOB} 

	# Append sas token to dest blob url
	DEST_BLOB="${DEST_BLOB}?${SAS_TOKEN}"

	copyCrossRegion ${SOURCE_BLOB} ${DEST_BLOB}

	BLOB_URL=$1
	NAME=$2
	RESOURCE_GROUP=$3
	SUBSCRIPTION=$4

	importFromBlob ${DEST_BLOB} ${DEST_NAME} ${DEST_RESOURCE_GROUP} ${DEST_SUBSCRIPTION}

}

