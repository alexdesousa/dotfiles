#!/bin/bash

###############################################################################
# BEGIN: Header

VERSION="1.4.8"
DESCRIPTION="Installs Browsh $VERSION"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMAND_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"
ROOT_SCRIPT="$1"
CURRENT_USER=""
CURRENT_HOME=""
if [ -z "$SUDO_USER" ]
then
  CURRENT_USER="$USER"
  CURRENT_HOME="$HOME"
else
  CURRENT_USER="$SUDO_USER"
  CURRENT_HOME=$(sudo -u "$SUDO_USER" -H -s eval 'echo $HOME')
fi
PROJECT_ROOT="$DIR/../../.."

shift

# END: Header
###############################################################################

###############################################################################
# BEGIN: Usage

function usage() {
  echo "
  $DESCRIPTION

  Usage:
    sudo ./$ROOT_SCRIPT $COMMAND_NAME [-h]

  Arguments:
    -h        - Shows this help.
    -u <USER> - Linux user.
  "

  exit "$1"
}

# END: Usage
###############################################################################

###############################################################################
# BEGIN: Arguments

while getopts :u:h option
do
  case "$option" in
    h)
      usage 0
      ;;
    u)
      CURRENT_USER="${OPTARG}"
      CURRENT_HOME=$(getent passwd "$CURRENT_USER" | cut -d':' -f6)
      ;;
    *)
      ;;
  esac
done

# END: Arguments
###############################################################################

###############################################################################
# BEGIN: Trap

WORKING_DIR=$(mktemp -d)
if [[ ! "$WORKING_DIR" || ! -d "$WORKING_DIR" ]]
then
  echo "Couldn't create temporal dir"
  exit 1
fi

function cleanup {
  rm -rf "$WORKING_DIR" 2> /dev/null
  exit 2
}

trap 'rm -rf "$WORKING_DIR"' EXIT
trap "cleanup" HUP INT QUIT TERM

# END: Trap
###############################################################################

###############################################################################
# BEGIN: Functions

##
# Installs dependencies
function install_dependencies {
  if [ ! -d "/opt/firefox" ] &&
     ! "$DIR/../firefox/main.sh" "$ROOT_SCRIPT" -u "$CURRENT_USER"
  then
    exit 1
  fi
}

##
# Installs package
function install_package {
  BASE_URL="https://github.com/browsh-org/browsh/releases/download"
  PACKAGE="browsh_${VERSION}_linux_amd64.deb"
  URL="$BASE_URL/v${VERSION}/$PACKAGE"

  wget "$URL" -O "$WORKING_DIR/browsh.deb"
  dpkg -i "$WORKING_DIR/browsh.deb"
}

##
# Adds alias
function add_alias {
  sed \
    -i '/^alias browsh="browsh --firefox\.path \/opt\/firefox\/firefox"$/d' \
    "$CURRENT_HOME/.zshrc"
  echo "$CURRENT_USER - $CURRENT_HOME"
  sudo \
    -u "$CURRENT_USER" \
    echo \
      -e 'alias browsh="browsh --firefox.path /opt/firefox/firefox"' >> "$CURRENT_HOME/.zshrc"
}

# END: Functions
###############################################################################

# END
###############################################################################

###############################################################################
# BEGIN: Main

function main {
  install_dependencies
  install_package
  add_alias

  exit $?
}

main

# END: Main
###############################################################################
