#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${PROJECT_ROOT}/.envrc"

ansible-playbook \
  -i "${PROJECT_ROOT}/hosts" "${PROJECT_ROOT}/exporter.yml" \
  --become-user="$USER" \
  --ask-vault-pass \
  -e "ansible_python_interpreter=$(which python3)"

(
  cd "$HOME/.password-store" &&
  git add "$HOME/.password-store/keys.tar.gz.enc" &&
  git commit -m ":closed_lock_with_key: Updated keys" &&
  git push origin master
)
