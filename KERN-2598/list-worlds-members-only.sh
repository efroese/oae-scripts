#!/bin/bash

#
# Find worlds in Sakai OAE that are visible by members only
#
# Erik Froese <erik@hallwaytech.com>


function usage(){
	echo "usage: list-worlds-bad-templateids.sh http://localhost:8080/ adminpassword"
}

if [[ -z $1 || -z $2 ]]; then
	usage
	exit 1
fi

OAE_URL=$1
OAE_PASSWORD=$2

ALL_IDS=`mktemp`
curl -s -uadmin:$OAE_PASSWORD --referer $OAE_URL -o $ALL_IDS "${OAE_URL}var/search/groups-all.tidy.json?q=*&sortOn=_lastModified&sortOrder=desc&category=course&page=0&items=200"

awk '/group-id/ { print $2 }' $ALL_IDS | sed 's/[",]//g' > $ALL_IDS.1
mv $ALL_IDS.1 $ALL_IDS

echo wc -l $ALL_IDS
wc -l $ALL_IDS

for id in `cat $ALL_IDS`; do
	world_info_file=`mktemp`

	curl -s -o $world_info_file -uadmin:$OAE_PASSWORD ${OAE_URL}system/userManager/group/$id.tidy.json

	grep -q "members-only" $world_info_file

	if [[ $? -eq 0 ]]; then
		echo  $id members-only
	fi
	rm $world_info_file
done
