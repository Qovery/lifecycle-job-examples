#!/bin/bash

set -e

# substitute QOVERY_ENVIRONMENT_ID by a shorter version - QOVERY_ENVIRONMENT_ID is too long for a lambda name (UUID v4)
export QOVERY_ENVIRONMENT_ID=$(echo "$QOVERY_ENVIRONMENT_ID" | cut -d "-" -f 1)

# Execute the given or default command:
/bin/bash -l -c "$*"
