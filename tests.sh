#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)
cd - > /dev/null

TMPDIR=/tmp/note-tests-$$
mkdir $TMPDIR

TESTDIR=$BASEDIR/tests
for FILE in $(ls $TESTDIR)
do
  $TESTDIR/$FILE $TMPDIR
  CODE=$?

  RESULT=""
  case $CODE in
    0)
      RESULT="${FILE}... ok"
      ;;
    *)
      RESULT="${FILE}... fail"
      ;;
  esac

  echo $RESULT
done

rm -rf $TMPDIR

