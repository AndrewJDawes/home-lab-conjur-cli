#!/usr/bin/env sh

ENTRYPOINT_ERROR=false
if [ -z "${CONJUR_SERVER_APPLIANCE_URL}" ]; then
  echo "CONJUR_SERVER_APPLIANCE_URL is required"
  ENTRYPOINT_ERROR=true
fi

if [ -z "${CONJUR_ORG_ACCOUNT}" ]; then
  echo "CONJUR_ORG_ACCOUNT is required"
  ENTRYPOINT_ERROR=true
fi

if [ -z "${CONJUR_USERNAME}" ]; then
  echo "CONJUR_USERNAME is required"
  ENTRYPOINT_ERROR=true
fi

if [ -z "${CONJUR_PASSWORD}" ]; then
  echo "CONJUR_PASSWORD is required"
  ENTRYPOINT_ERROR=true
fi

if [ "${ENTRYPOINT_ERROR}" = "true" ]; then
  exit 1
fi

init_command="conjur init -u ${CONJUR_SERVER_APPLIANCE_URL} -a ${CONJUR_ORG_ACCOUNT} --force"

# if CONJUR_CLI_INSECURE is set to true, then add the -i flag

if [ "${CONJUR_CLI_INSECURE}" = "true" ]; then
  init_command="${init_command} -i"
fi

eval "${init_command}"

# wait for conjur to be ready
echo "Checking if Conjur is ready..."
until conjur whoami 1>/dev/null 2>&1; do
  echo "Waiting for Conjur to be ready..."
  sleep 1
done

conjur login -i "${CONJUR_USERNAME}" -p "${CONJUR_PASSWORD}"

exec "$@"
