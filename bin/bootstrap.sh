#!/usr/bin/env bash

set -e

##################
# Global variables

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_VARS="$ROOTDIR/.envrc"
DOTFILES_HOSTS="$ROOTDIR/hosts"
DOTFILES_PLAYBOOK="$ROOTDIR/dotfiles.yml"

###########
# Functions

# Prints an error.
function __bootstrap_error {
  local message="$1"

  (>&2 echo -e "\033[1;91m[ERROR]    $message\033[0;0m")
}

# Prints bootstrap usage.
function __bootstrap_usage {
  if [ -n "$2" ]
  then
    __bootstrap_error "$2"
  fi

  echo "
  Installs new system given some environment variables.

  Usage:
    # $0 [-t <TAG> -h]

  Arguments:
    -h       - Shows this help.
    -t <TAG> - Role tag

  Environment variables:
    DOTFILES_BOOTSTRAP_USER      - Linux user.
    DOTFILES_BOOTSTRAP_GIT_NAME  - Git user name.
    DOTFILES_BOOTSTRAP_GIT_EMAIL - Git user e-mail.
  "

  exit "$1"
}

###########
# Arguments

while getopts :t:h option
do
  case "$option" in
    h)
      __bootstrap_usage 0
      ;;
    t)
      TAG="${OPTARG}"
      ;;
    *)
      ;;
  esac
done

source "$DOTFILES_VARS" 2> /dev/null

if [ -z "$DOTFILES_BOOTSTRAP_USER" ]
then
  __bootstrap_usage 1 "Cannot find variable DOTFILES_BOOTSTRAP_USER"
fi

if [ -z "$DOTFILES_BOOTSTRAP_GIT_NAME" ]
then
  __bootstrap_usage 1 "Cannot find variable DOTFILES_BOOTSTRAP_GIT_NAME"
fi

if [ -z "$DOTFILES_BOOTSTRAP_GIT_EMAIL" ]
then
  __bootstrap_usage 1 "Cannot find variable DOTFILES_BOOTSTRAP_GIT_EMAIL"
fi

if [ -z "$TAG" ]
then
  TAG="all"
fi

DOTFILES_BOOTSTRAP_ROOT="$ROOTDIR"
DOTFILES_BOOTSTRAP_USER_HOME=$(
  getent passwd "$DOTFILES_BOOTSTRAP_USER" |
  cut -d: -f6
)

###########
# Bootstrap

apt-get update && apt-get install -y sudo ansible

adduser "$DOTFILES_BOOTSTRAP_USER" sudo

sudo -u "$DOTFILES_BOOTSTRAP_USER" \
  DOTFILES_BOOTSTRAP_ROOT="$DOTFILES_BOOTSTRAP_ROOT" \
  DOTFILES_BOOTSTRAP_USER="$DOTFILES_BOOTSTRAP_USER" \
  DOTFILES_BOOTSTRAP_USER_HOME="$DOTFILES_BOOTSTRAP_USER_HOME" \
  DOTFILES_BOOTSTRAP_GIT_NAME="$DOTFILES_BOOTSTRAP_GIT_NAME" \
  DOTFILES_BOOTSTRAP_GIT_EMAIL="$DOTFILES_BOOTSTRAP_GIT_EMAIL" \
  ansible-playbook -i "$DOTFILES_HOSTS" "$DOTFILES_PLAYBOOK" \
  --ask-become-pass \
  --tags "$TAG"

exit 0
