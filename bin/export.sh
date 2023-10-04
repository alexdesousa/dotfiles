#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CREDENTIALS="$(mktemp -d)"
trap 'rm -rf -- "$CREDENTIALS"' EXIT
echo "$VAULT_PASSWORD" > "$CREDENTIALS/vault_password"

ansible-playbook \
  -i "${PROJECT_ROOT}/hosts" "${PROJECT_ROOT}/exporter.yml" \
  --ask-become-pass \
  --vault-password-file "$CREDENTIALS/vault_password" \
  -e "ansible_python_interpreter=/bin/python3"

(
  cd "$HOME/.password-store" &&
  git add "$HOME/.password-store/keys.tar.gz.enc" &&
  git commit -m ":closed_lock_with_key: Updated keys" &&
  git push origin master
)
