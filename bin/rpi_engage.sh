#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CREDENTIALS="$(mktemp -d)"
trap 'rm -rf -- "$CREDENTIALS"' EXIT
echo "$VAULT_PASSWORD" > "$CREDENTIALS/vault_password"

if [ -z "$1" ]
then
  ansible-playbook \
    -i "${PROJECT_ROOT}/hosts" "${PROJECT_ROOT}/rpi_engage.yml" \
    --vault-password-file "$CREDENTIALS/vault_password" \
    -e "ansible_python_interpreter=/bin/python3 ansible_user=pi ansible_password='$RPI_PASSWORD'"
else
  ansible-playbook \
    -i "${PROJECT_ROOT}/hosts" "${PROJECT_ROOT}/rpi_engage.yml" \
    --vault-password-file "$CREDENTIALS/vault_password" \
    -e "ansible_python_interpreter=/bin/python3 ansible_user=pi ansible_password='$RPI_PASSWORD'" \
    --tags "$1"
fi
