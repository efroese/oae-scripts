#!/bin/bash
#
# Make the world a viewer of the world-{student,ta,lecturer} groups
#
# Erik Froese <erik@hallwaytech.com>
#

function usage() {
	echo "usage: add-world-as-viewers.sh http://localhost:8080/ adminpassword my-oae-world"
}

if [[ -z $1 || -z $2 || -z $3 ]]; then
	usage
	exit 1
fi

OAE_URL=$1
OAE_PASSWORD=$2
WORLD_ID=$3

for role in student ta lecturer; do
    curl --referer ${OAE_URL} -uadmin:${OAE_PASSWORD} -F":viewer=$WORLD_ID" \
        ${OAE_URL}system/userManager/group/${WORLD_ID}-${role}.update.json
    echo
done
