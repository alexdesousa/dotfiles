#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Sets zsh"

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
apt install -y zsh

chsh -s /bin/zsh
sudo -u $CURRENT_USER chsh -s /bin/zsh

rm -rf /root/.oh-my.zsh
sudo -u $CURRENT_USER \
  rm -rf $CURRENT_HOME/.oh-my-zsh

OMZ="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

sh -c "$(wget "$OMZ" -O -)"
sudo -u $CURRENT_USER \
  sh -c "$(wget "$OMZ" -O -)"
sudo -u $CURRENT_USER \
  sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="candy"/gi' $CURRENT_HOME/.zshrc

cat $ETC/auto_env >> $CURRENT_HOME/.zshrc

# END
###############################################################################

exit 0
