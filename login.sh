#!/bin/sh

if [ -z "${1}" ] || [ -z "${2}" ]; then
	echo "Missing configuration"
	exit
fi

CONFIG=$(./bin/parseYaml.sh "${1}" | sed 's/"//g')

declare ${CONFIG}

if [ "${2}" == "source" ]; then
	az login --tenant ${SOURCE_TENANT}
elif [ "${2}" == "dest" ]; then
	az login --tenant ${DEST_TENANT}
fi

