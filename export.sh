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

	echo ${EXPORT_OUTPUT}
}

main() {

	CONFIG=`./load-config.sh ${1}`
	declare ${CONFIG}

	# TOKEN=`./get-token.sh ${SOURCE_BLOB_TYPE} ${SOURCE_BLOB_STORAGE_ACC} ${SOURCE_BLOB_CONTAINER}`
	SOURCE_TOKEN=`cat ./source-sas`

	## Append sas token to source blob url
	SOURCE_BLOB_URL="${SOURCE_BLOB_URL}${SOURCE_TOKEN}"

	echo "Export to Blob ${SOURCE_BLOB_URL}"

	RESP=`exportRedis ${SOURCE_BLOB_CONTAINER} ${SOURCE_BLOB_PREFIX} ${SOURCE_NAME} ${SOURCE_RESOURCE_GROUP} ${SOURCE_SUBSCRIPTION}`
	echo "export result: ${RESP}"
}

if [ "${1}" != "--source-only" ]; then
	echo "Start processing..."
  main "${@}"
fi

