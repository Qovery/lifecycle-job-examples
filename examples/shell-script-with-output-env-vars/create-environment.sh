#!/bin/sh

# exit on error
set -e

VARNAME1_VALUE="myvalue1"
VARNAME2_VALUE="myvalue2"

# Read Qovery Lifecycle Job Output Documentation: https://hub.qovery.com/docs/using-qovery/configuration/lifecycle-job/#job-output
echo '{
  "varname1": {
    "sensitive": true,
    "value": "'$VARNAME1_VALUE'"
  },
  "varname2": {
    "sensitive": false,
    "value": "'$VARNAME2_VALUE'"
  }
}' > /qovery-output/qovery-output.json

echo "shell script executed successfully with output values - check out your Qovery environment variables :)"
