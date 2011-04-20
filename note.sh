#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)
cd - > /dev/null

. $BASEDIR/config
. $BASEDIR/lib/init.sh


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
  tag <NOTE> <TAG>...  Tag existing note with specific tags
  repo [REPO]          Display the current repository or, if a valid directory
                       is given change the current repository. (Use '-' to
                       change back)
EoT
}


# Main
#
ACTION=$1
shift

case $ACTION in
  "new")
    $BASEDIR/bin/note-new.sh $@
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
              die "tag does not exist"
            fi
          done
          if [ "$TAGC" -eq "$#" ]; then
            echo $NOTE
          fi
        done
      else
        die "tag does not exist"
      fi
    fi
    ;;
  "cat" | "edit")
    FILE=$(file_for_id $1)
    [ -z "$FILE" ] && die "no note with id $1"
    if [ "$ACTION" == "edit" ]; then
      $EDITOR $REPO/$FILE
    else
      cat $REPO/$FILE
    fi
    ;;
  "tags")
    if [ "$#" -gt "0" ]; then
      $BASEDIR/bin/note-tag-ls.sh $@
    else
      for TAG in $(wc -l $TAGDIR/* | sort -r | sed -e 's/ *//' | cut -d\  -f2 | sed -e '1d')
      do
        echo $(basename $TAG)
      done
    fi
    ;;
  "tag")
    $BASEDIR/bin/note-tag.sh $@
    ;;
  "repo")
    DIR=$1
    if [ -z "$DIR" ]; then
      echo $REPO
    else
      if [ "$DIR" == "-" ]; then
        if [ -e "$BASEDIR/config.swp" ]; then
          mv $BASEDIR/config.swp $BASEDIR/config
          echo "REPO=$REPO" > $BASEDIR/config.swp
        fi
      else
        [ ! -d "$DIR" ] && die "no valid repository specified"

        mv $BASEDIR/config $BASEDIR/config.swp
        echo "REPO=$DIR" > $BASEDIR/config
      fi
    fi
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

