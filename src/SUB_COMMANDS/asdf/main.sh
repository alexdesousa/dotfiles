#!/bin/bash

###############################################################################
# BEGIN
# SAME FOR EVERY TASK

#################
# Basic variables

DESCRIPTION="Sets asdf."

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

##############
# Install asdf

if [ ! -f "$CURRENT_HOME/.zshrc" ]
then
  $DIR/../zsh/main.sh $ROOT_SCRIPT -u $CURRENT_USER
fi

ASDF_VERSION=v0.4.3
rm -rf $CURRENT_HOME/.asdf
sed -i '/^\. \$HOME\/.asdf\/asdf\.sh$/d' $CURRENT_HOME/.zshrc
sed -i '/^\. \$HOME\/.asdf\/completions\/asdf\.bash$/d' $CURRENT_HOME/.zshrc
sudo -u $CURRENT_USER \
  git clone https://github.com/asdf-vm/asdf.git $CURRENT_HOME/.asdf --branch $ASDF_VERSION
sudo -u $CURRENT_USER \
  echo -e '. $HOME/.asdf/asdf.sh' >> $CURRENT_HOME/.zshrc
sudo -u $CURRENT_USER \
  echo -e '. $HOME/.asdf/completions/asdf.bash' >> $CURRENT_HOME/.zshrc

# END
###############################################################################

exit 0
