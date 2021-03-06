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
  new [TAG]...         Create a new note and associate it with tags
  ls, list [TAG]...    List all notes associated with the specified tags
  cat <NOTE>           Print note to standard output
  edit <NOTE>          Open note in default editor
  tags [NOTE]          List all tags sorted by occurrence, or, if a note is
                       specified, show all tags associated with the note
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
  "ls" | "list")
    TAG=$1
    if [ -z "$TAG" ]; then
      ls $REPO | sort
    else
      if [ -e "$TAGDIR/$TAG" ]; then
        for NOTE in $(cat $TAGDIR/$TAG)
        do
          TAGC=0
          for TAG in $@
          do
            if [ -e "$TAGDIR/$TAG" ]; then
              TAGC=$(expr $TAGC + $(grep -c $NOTE $TAGDIR/$TAG))
            else
              echo "error: tag does not exist"
              exit 1
            fi
          done
          if [ "$TAGC" -eq "$#" ]; then
            echo $NOTE
          fi
        done
      else
        echo "error: tag does not exist"
        exit 1
      fi
    fi
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
    NOTE=$1
    if [ -z "$NOTE" ]; then
      for TAG in $(wc -l $TAGDIR/* | sort -r | sed -e 's/ *//' | cut -d\  -f2 | sed -e '1d')
      do
        echo $(basename $TAG)
      done
    else
      if [ ! -e "$REPO/$NOTE" ]; then
        echo "error: note does not exist"
        exit 1
      fi
      for TAG in $(grep -l $NOTE $TAGDIR/* | sort)
      do
        echo $(basename $TAG)
      done
    fi
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

