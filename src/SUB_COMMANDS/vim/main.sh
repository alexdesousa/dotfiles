#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Sets up a Vim installation (tmux included)."

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

apt update
apt install -y vim tmux

#########
# Set vim

rm -rf $CURRENT_HOME/.vim
sudo -u $CURRENT_USER \
  git clone https://github.com/VundleVim/Vundle.vim.git $CURRENT_HOME/.vim/bundle/Vundle.vim
sudo -u $CURRENT_USER \
  cp $ETC/vimrc $CURRENT_HOME/.vimrc
sudo -u $CURRENT_USER \
  vim +PluginInstall +qall

##########
# Set TMux

sudo -u $CURRENT_USER cp $ETC/tmux.conf $CURRENT_HOME/.tmux.conf

# END
###############################################################################

exit 0
