#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Installs Docker."

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

# docker

apt update
apt install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt update
apt install -y docker-ce

usermod -a -G docker $CURRENT_USER

sudo -u $CURRENT_USER docker run hello-world

# docker-compose

VERSION=1.21.2
FILE=$VERSION/docker-compose-$(uname -s)-$(uname -m)

curl \
  -L https://github.com/docker/compose/releases/download/$FILE \
  -o /usr/local/bin/docker-compose

chmod -o /usr/local/bin/docker-compose

# END
###############################################################################

exit 0
