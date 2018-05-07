#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Sets erlang latest version."

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMAND_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"
ROOT_SCRIPT="$1"
CURRENT_USER=""
CURRENT_HOME=""
if [ -z $SUDO_USER ]
then
  CURRENT_USER=$USER
  CURRENT_HOME=$HOME
else
  CURRENT_USER=$SUDO_USER
  CURRENT_HOME=$(sudo -u $SUDO_USER echo $HOME)
fi
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

##############
# Install asdf

if [ ! -d "$CURRENT_HOME/.asdf" ]
then
  $DIR/../asdf/main.sh $ROOT_SCRIPT -u $CURRENT_USER
fi

apt -y install build-essential
apt -y install autoconf
apt -y install m4
apt -y install libncurses5-dev
apt -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng16-16
apt -y install libssh-dev
apt -y install unixodbc-dev

sudo -u $CURRENT_USER \
  $DIR/user.sh $ROOT_SCRIPT $@

# END
###############################################################################

exit 0
