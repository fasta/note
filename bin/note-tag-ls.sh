#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)
cd - > /dev/null

. $(dirname $BASEDIR)/config
. $(dirname $BASEDIR)/lib/init.sh


# Parse args
ID=""
TAG=""

while [ "$#" -gt "0" ]
do
  case $1 in
    "-i" | "--id")
      ID=$2
      shift
      ;;
    "-t" | "--tag")
      TAG=$2
      shift
      ;;
    *)
      ID=$1
      shift
  esac
done


if [ ! -z "$TAG" ]; then
  TAGFILE=$TAGDIR/$TAG

  # Recursively list tags associated with given tag
  if [ -e "$TAGFILE" ]; then
    for FILE in $(cat $TAGFILE)
    do
      $0 --id $FILE
    done | sort -u
  fi
else
  FILE=$(file_for_id $ID)

  for TAG in $(grep -l $FILE $TAGDIR/* | sort)
  do
    echo $(basename $TAG)
  done
fi

