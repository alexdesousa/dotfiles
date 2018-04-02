#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Sets base system."

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
    sudo ./$ROOT_SCRIPT $COMMAND_NAME [-h]

  Arguments:
    -h        - Shows this help.
    -u <USER> - Linux user.
  "

  exit $1
}

while getopts :u:h option
do
  case "$option" in
    h)
      usage 0
      ;;
    u)
      CURRENT_USER="${OPTARG}"
      CURRENT_HOME=$(getent passwd $CURRENT_USER | cut -d: -f6)
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

############################
# Install necessary packages

SOURCES=$(
  cat /etc/apt/sources.list |
  sed 's/debian\/ .* main .*$/debian\/ testing main contrib non-free/gi' |
  sed 's/debian-security .*\/updates main$/debian-security testing\/updates main/'
)
echo "$SOURCES" > /etc/apt/sources.list
dpkg --add-architecture i386
apt update
apt upgrade
apt install -y \
  guake python-gi-cairo python-gobject \
        curl git intel-microcode firmware-realtek \
        firmware-atheros bumblebee-nvidia primus \
        primus-libs:i386 mate-tweak
apt autoremove

####################
# Add user to groups

adduser $CURRENT_USER sudo
adduser $CURRENT_USER bumblebee

###################
# Install utilities

$DIR/../zsh/main.sh zsh $ROOT_SCRIPT -u $CURRENT_USER
$DIR/../vim/main.sh vim $ROOT_SCRIPT -u $CURRENT_USER
$DIR/../asdf/main.sh asdf $ROOT_SCRIPT -u $CURRENT_USER

# END
###############################################################################

exit 0
