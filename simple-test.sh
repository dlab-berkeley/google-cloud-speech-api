#!/bin/bash -ex

## by hand run this command with whatever your key is called
## (replace foo-key.json with the name of your key):
##
##    cp $HOME/foo-key.json $HOME/simple-test-key.json

# points to the service account key file
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/simple-test-key.json

# gets a new access token based on the service account key file
TOKEN=$(gcloud auth application-default print-access-token)

# This edits the metadata the API expects.  make sure it’s the same as the file you are converting.
cat > simple-test.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "sampleRateHertz": 160000,
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-tests/speech/brooklyn.flac"
  }
}
EOF

#
curl -s -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/speech:longrunningrecognize     -d @simple-test.json > simple-test.status
JOBID=$(cat simple-test.status | jq .name)
echo Waiting for job $JOBID to finish
sleep 3

curl -s -k -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/operations/$JOBID > simple-test-output.json

echo <<EOF
Run this command again if the job is not yet done:

curl -s -k -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/operations/$JOBID > simple-test-output.json
EOF
