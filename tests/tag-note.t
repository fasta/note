#!/bin/bash

N=$(dirname $0)/../note-tag.sh

TMPDIR=$1

# Tag a already tagged note with the same tag
#
NOTE=test
touch $TMPDIR/$NOTE
$N --repo $TMPDIR --note $NOTE --tag foo --tag bar

$N --repo $TMPDIR --note $NOTE --tag foo

TAGS="foo bar"
for TAG in $TAGS
do
  if [ "$(grep -c $NOTE $TMPDIR/.tags/$TAG)" -ne "1" ]; then
    exit 1
  fi
done

