#!/bin/bash

#
# Set the templateid for the course
#
# Erik Froese <erik@hallwaytech.com>
#

function usage() {
	echo "usage: set-world-template.sh http://localhost:8080/ adminpassword basic-course my-oae-world"
}

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then
	usage
	exit 1
fi

OAE_URL=$1
OAE_PASSWORD=$2
TEMPLATEID=$3
WORLDID=$4

curl --referer ${OAE_URL} -uadmin:${OAE_PASSWORD} -F"sakai:templateid=${TEMPLATEID}" ${OAE_URL}system/userManager/group/${WORLDID}.update.json
