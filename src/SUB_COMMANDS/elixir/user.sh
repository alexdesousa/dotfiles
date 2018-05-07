#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Sets elixir in its latest version."

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMAND_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"
ROOT_SCRIPT="$1"
PROJECT_ROOT=$DIR/../../..
ETC=$PROJECT_ROOT/etc

shift

###########
# Arguments

function usage() {
  echo "
  $DESCRIPTION

  Usage:
    sudo ./$ROOT_SCRIPT $COMMAND_NAME [-v <VERSION> -h]

  Arguments:
    -h           - Shows this help.
    -u <USER>    - Linux user.
    -v <VERSION> - NodeJS version.
  "

  exit $1
}

while getopts :u:v:h option
do
  case "$option" in
    h)
      usage 0
      ;;
    u)
      CURRENT_USER="${OPTARG}"
      CURRENT_HOME=$(getent passwd $CURRENT_USER | cut -d: -f6)
      ;;
    v)
      VERSION="${OPTARG}"
      ;;
    *)
      ;;
  esac
done

# END
###############################################################################

###############################################################################
# BEGIN
# FUNCTIONALITY

###########
# Init asdf

. $CURRENT_HOME/.asdf/asdf.sh
. $CURRENT_HOME/.asdf/completions/asdf.bash

#######################
# Install erlang plugin

asdf plugin-add elixir

####################
# Get nodejs version

if [ -n "$VERSION" ]
then
  SELECTED="$VERSION"
  VERSION="$(asdf list-all elixir | grep "$VERSION")"
  if [ -z "$VERSION" ]
  then
    echo "Version $SELECTED is not available in asdf"
    echo "List possible versions with 'asdf list-all elixir'"
    exit 1
  fi
fi

if [ -z "$VERSION" ]
then
  VERSION=$(asdf list-all elixir | tail -n1)
fi

################
# Install nodejs

asdf install elixir "$VERSION"
asdf global elixir "$VERSION"

exit 0
