#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)
cd - > /dev/null

. $(dirname $BASEDIR)/config
. $(dirname $BASEDIR)/lib/init.sh


# Parse args
ID=$1
shift

FILE=$(file_for_id $ID)
[ -z "$FILE" ] && die "no note with id $ID"


for TAG in $@
do
  TAGFILE="$TAGDIR/$TAG"

  touch $TAGFILE
  if [ "$(grep -c $FILE $TAGFILE)" -lt "1" ]; then
    echo $FILE >> $TAGFILE
  fi
done

