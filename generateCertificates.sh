#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

CA_NAME=${1:-}
SERVICES=${2:-}

if [[ -z "$CA_NAME" || -z "${SERVICES}" ]]; then
  echo "CA_NAME and SERVICE[,SERVICE,...] parameters required"
  echo "Usage: $0 CA_NAME SERVICE[,SERVICE,...]"
  exit 1
fi

# Some certstrap options
DEPOT_PATH=certificates
EXPIRES="10 years"
KEY_BITS=4096

certstrap_with_opts () {
  certstrap --depot-path "${DEPOT_PATH}" "$@"
}

generateCA () {
  if [[ -f "${DEPOT_PATH}/${CA_NAME}.crt" ]]; then
    echo "CA \"${CA_NAME}\" already exists"
    return
  fi

  echo "Generate root CA \"${CA_NAME}\""
  certstrap_with_opts init --passphrase "" --expires "${EXPIRES}" --common-name "${CA_NAME}"
}

requestAndSignCertificate () {
  local SERVICE=$1
  echo "Create certificate request for ${SERVICE}"
  certstrap_with_opts request-cert --passphrase "" --key "${DEPOT_PATH}/${CA_NAME}.key" --key-bits "${KEY_BITS}" --common-name "${SERVICE}" --domain "${SERVICE},localhost"
  echo "Sign certificate request for ${SERVICE}"
  certstrap_with_opts sign --passphrase "" --expires "${EXPIRES}" --CA "${CA_NAME}" "${SERVICE}"
}

generateCA

SERVICES=${SERVICES//,/$'\n'}
for SERVICE in $SERVICES
do
  requestAndSignCertificate "${SERVICE}"
done