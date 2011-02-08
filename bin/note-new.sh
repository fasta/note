#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)
cd - > /dev/null

. $(dirname $BASEDIR)/config
. $(dirname $BASEDIR)/lib/init.sh


# Parse args
ID=""
TAGS=""

while [ "$#" -gt "0" ]
do
  if [ "$1" == "--id" ]; then
    ID=$2
    shift
  else
    TAGS="$TAGS $1"
  fi
  shift
done


# Generate ID
[ -z "$ID" ] && ID=$(date +%Y%m%d%H%M%S)


# Open note in editor
FILE="$ID.mdwn"
$EDITOR "$REPO/$FILE"


# Tag note
if [ "$?" -eq "0" ]; then
  $BASEDIR/note-tag.sh $ID $TAGS
fi

