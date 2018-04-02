#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Installs Ganache."

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
    sudo ./$ROOT_SCRIPT $COMMAND_NAME [-h -v <VERSION>]

  Arguments:
    -h           - Shows this help.
    -u <USER>    - Linux user.
    -v <VERSION> - Ganache version.
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

if [ -d "$CURRENT_HOME/Apps/ganache" ]
then
  rm -rf $CURRENT_HOME/Apps/ganache
fi

if [ -z $VERSION ]
then
  VERSION="1.1.0"
fi

BASE_URL="https://github.com/trufflesuite/ganache/releases/download"
URL="$BASE_URL/v${VERSION}/ganache-${VERSION}-x86_64.AppImage"
sudo -u $CURRENT_USER mkdir -p $CURRENT_HOME/Apps/ganache
sudo -u $CURRENT_USER wget $URL -O $CURRENT_HOME/Apps/ganache/ganache.AppImage
sudo -u $CURRENT_USER chmod +x $CURRENT_HOME/Apps/ganache/ganache.AppImage


#################
# Create launcher

FILE=$(echo "#!/usr/bin/env xdg-open

[Desktop Entry]
Name=Ganache
Comment=Personal Blockchain for Ethereum
Exec="$CURRENT_HOME/Apps/ganache/ganache.AppImage" %U
Terminal=false
Type=Application
Icon=appimagekit-Ganache
TryExec=$CURRENT_HOME/Apps/ganache/ganache.AppImage")

DESKTOP=$CURRENT_HOME/Desktop
sudo -u $CURRENT_USER bash -c "echo \"$FILE\" > $DESKTOP/ganache.desktop"
sudo -u $CURRENT_USER chmod +x $DESKTOP/ganache.desktop

# END
###############################################################################

exit 0
