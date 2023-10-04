#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CREDENTIALS="$(mktemp -d)"
trap 'rm -rf -- "$CREDENTIALS"' EXIT
echo "$VAULT_PASSWORD" > "$CREDENTIALS/vault_password"

ansible-playbook \
  -i "${PROJECT_ROOT}/hosts" "${PROJECT_ROOT}/engage.yml" \
  --become-user="$USER" \
  --vault-password-file "$CREDENTIALS/vault_password" \
  -e "ansible_python_interpreter=$(which python3)"
