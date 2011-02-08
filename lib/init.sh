[ ! -d "$REPO" ] && echo "error: invalid config" && exit 1

TAGDIR=$REPO/.tags
mkdir -p $TAGDIR


function die()
{
  cat <<EoT
error: $@
EoT
  exit 1
}

function file_for_id()
{
  ID=$1
  [ ! -e "$REPO/$ID" ] && ID="$ID.mdwn"
  [ ! -e "$REPO/$ID" ] && ID=""
  echo $ID
}

