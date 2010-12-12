#!/bin/bash

# Helpers
#
function usage()
{
  cat<<EoT
usage: $(basename $0) <required> [optional]...

Required options:
  -r, --repo <REPO>    Note repository
  -n, --note <NOTE>    Name of the note about to be edited

Optional options:
  -t, --tag <TAG>      Tag associated with the note

EoT
}

# Main
#
set -- `getopt --longoptions="repo: note: tag:" "h" "$@"`

while [ "$#" -gt "0" ]
do
  case $1 in
    "-r" | "--repo")
      REPO=$2
      shift
      ;;
    "-n" | "--note")
      NOTE=$2
      shift
      ;;
    "-t" | "--tag")
      TAGS="$2 $TAGS"
      shift
      ;;
  esac
  shift
done

[[ -z "$REPO" || -z "$NOTE" ]] && usage && exit 1

TAGDIR=$REPO/.tags
mkdir -p $TAGDIR

FILE="$REPO/$NOTE"
if [ ! -e "$FILE" ]; then
  echo "error: note does note exist" >&2
  exit 1
fi

for TAG in $TAGS
do
  TAGFILE=$TAGDIR/$TAG

  touch $TAGFILE
  if [ "$(grep -c $NOTE $TAGFILE)" -lt "1" ]; then
    echo $NOTE >> $TAGFILE
  fi
done

