#!/bin/sh

set -e

# substitute QOVERY_ENVIRONMENT_ID by a shorter version - QOVERY_ENVIRONMENT_ID is too long for a lambda name (UUID v4)
export QOVERY_ENVIRONMENT_ID=$(echo "$QOVERY_ENVIRONMENT_ID" | cut -d "-" -f 1)

serverless deploy --stage $QOVERY_ENVIRONMENT_ID
serverless manifest --stage $QOVERY_ENVIRONMENT_ID -p qovery-output.js
