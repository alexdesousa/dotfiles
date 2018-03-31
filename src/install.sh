#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_NAME=$(basename "${BASH_SOURCE[0]}")

function usage() {
  echo ""
  if [ -n $2 ]
  then
    echo "ERROR: Unknown subcommand '$2'"
    echo ""
  fi
  echo "Usage as root:
  $BASE_NAME <SUB COMMAND> -u <USER> [-h]"
  echo "Usage as sudoer:
  sudo $BASE_NAME <SUB COMMAND> [-u <USER> -h]"
  echo "Available subcommands:"
  echo "$(ls $DIR/SUB_COMMANDS)"

  exit $1
}

SUB_COMMAND=$1
case $SUB_COMMAND in
  "" | "-h" | "--help")
    usage 0
    ;;
  *)
    shift
    $DIR/SUB_COMMANDS/$SUB_COMMAND/main.sh $BASE_NAME $@
    if [ $? -eq 127 ]
    then
      usage 1 $SUB_COMMAND
    fi
esac
