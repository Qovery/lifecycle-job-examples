#!/usr/bin/env bash

# exit on error
set -e

export SHORT_QOVERY_ENVIRONMENT_ID=$(echo "$QOVERY_ENVIRONMENT_ID" | cut -d "-" -f 1)
export STACK_NAME="${STACK_NAME_PREFIX}-${SHORT_QOVERY_ENVIRONMENT_ID}"

# Execute CMD command
exec "$@"
