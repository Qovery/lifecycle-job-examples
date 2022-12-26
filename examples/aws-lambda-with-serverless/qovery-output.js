'use strict';

const fs = require('fs');

module.exports = async function processManifest(manifestData) {
  // to get the manifest data, you can use the following command:
  // serverless manifest --json

  const qoveryEnvironmentId = process.env.QOVERY_ENVIRONMENT_ID;

  const qoveryOutputFileContent = {
    "HELLO_FUNCTION_ENDPOINT_URL": {
      "value": manifestData[qoveryEnvironmentId].urls.httpApi,
      "type": "string",
      "sensitive": false,
    },
  };

  fs.writeFile('/qovery-output/qovery-output.json', JSON.stringify(qoveryOutputFileContent, null, 2), function (err) {
    if (err) {
      console.log(err);
    } else {
      console.log('/qovery-output/qovery-output.json Saved!');
    }
  });

  console.log(qoveryOutputFileContent);
}
