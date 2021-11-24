#!/bin/bash

load() {
	if [ -z "$1" ]; then
		echo "Missing configuration"
		exit
	fi

	CONFIG=$(./bin/parseYaml.sh "${1}" | sed 's/"//g')

	echo $CONFIG


#	echo $SOURCE_SUBSCRIPTION
}

if [ "${1}" != "--source-only" ]; then
	echo "loading configuration"
	load "${@}"
fi

