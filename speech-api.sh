#!/bin/bash

NAME=brooklyn

# To do
# 1. Setup (one time only) 

# enable the APIs: speech, compute engine, cloud storage

# create a service account 

# download the service account key file to your laptop, then upload it to google cloud shell

# set variable for file name

# make sure for the default test to download this file and upload it to your own bucket:
#  gsutil cp gs://cloud-samples-tests/speech/brooklyn.flac .

## by hand run this command with whatever your key is called
## (replace foo-key.json with the name of your key):
##
##    cp $HOME/foo-key.json $HOME/simple-test-key.json

# points to the service account key file
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/simple-test-key.json

# gets a new access token based on the service account key file
TOKEN=$(gcloud auth application-default print-access-token)

# This edits the metadata the API expects.  make sure it’s the same as the file you are converting.
cat > ${NAME}.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "sampleRateHertz": 44100,
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://audio-test-123/${NAME}.flac"
  }
}
EOF

#
curl -s -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/speech:longrunningrecognize     -d @${NAME}.json > ${NAME}.status
JOBID=$(cat ${NAME}.status | jq -r .name)
echo Waiting for job $JOBID to finish
sleep 3

curl -s -k -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/operations/$JOBID > ${NAME}-output.json
cat ${NAME}-output.json

cat <<EOF
Run these commands again if the job is not yet done:

curl -s -k -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/operations/$JOBID > ${NAME}-output.json
cat ${NAME}-output.json
EOF
