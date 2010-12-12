#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)
cd - > /dev/null

. $BASEDIR/config

if [ ! -d "$REPO" ]; then
  echo "error: invalid config" >&2
  exit 1
fi

TAGDIR=$REPO/.tags
mkdir -p $TAGDIR


# Helpers
#
function usage()
{
  cat<<EoT
usage: $(basename $0) <action>

Actions:
  new [TAG]...
  list
  cat <NOTE>
  edit <NOTE>
  tags
EoT
}


# Main
#
ACTION=$1
shift

case $ACTION in
  "new")
    NOTE=$(date +%Y%m%d%H%M%S)
    $EDITOR $REPO/$NOTE
    if [ "$?" -eq "0" ]; then
      for ARG in $@
      do
        TAGS="--tag $ARG $TAGS"
      done
      $BASEDIR/note-tag.sh --repo $REPO --note $NOTE $TAGS
    fi
    ;;
  "list")
    ls $REPO | sort
    ;;
  "cat" | "edit")
    NOTE=$REPO/$1
    if [ ! -e "$NOTE" ]; then
      echo "error: note does not exist"
      exit 1
    fi
    if [ "$ACTION" == "edit" ]; then
      $EDITOR $NOTE
    else
      cat $NOTE
    fi
    ;;
  "tags")
    for TAG in $(ls $TAGDIR | sort)
    do
      echo $TAG
    done
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

