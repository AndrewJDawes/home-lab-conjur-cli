#!/usr/bin/env bash

if [ -z "${CONJUR_SERVER_APPLIANCE_URL}" ]; then
  echo "CONJUR_SERVER_APPLIANCE_URL is required"
  exit 1
fi

if [ -z "${CONJUR_ORG_ACCOUNT}" ]; then
  echo "CONJUR_ORG_ACCOUNT is required"
  exit 1
fi

if [ -z "${CONJUR_USERNAME}" ]; then
  echo "CONJUR_USERNAME is required"
  exit 1
fi

if [ -z "${CONJUR_PASSWORD}" ]; then
  echo "CONJUR_PASSWORD is required"
  exit 1
fi

init_command="conjur init -u ${CONJUR_SERVER_APPLIANCE_URL} -a ${CONJUR_ORG_ACCOUNT} --force"

# if CONJUR_CLI_INSECURE is set to true, then add the -i flag

if [ "${CONJUR_CLI_INSECURE}" = "true" ]; then
  init_command+=" -i"
fi

eval "${init_command}"

conjur login -i "${CONJUR_USERNAME}" -p "${CONJUR_PASSWORD}"

exec "$@"
