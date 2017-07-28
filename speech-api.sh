#!/bin/bash

# To do
# 1. Setup (one time only) 

# enable the APIs: speech, compute engine, cloud storage

# create a service account 

# download the service account key file to your laptop, then upload it to google cloud shell

# set variable for file name

# points to the service account key file
export GOOGLE_APPLICATION_CREDENTIALS=gc-speech-api-79f84132db5f.json

# gets a new access token based on the service account key file
TOKEN=$(gcloud auth application-default print-access-token)

# This edits the metadata the API expects.  make sure it’s the same as the file you are converting.
cat > Lewis.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "sampleRateHertz": 44100,
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://audio-test-123/Lewis.flac"
  }
}
EOF

#
curl -s -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/speech:longrunningrecognize     -d @Lewis.json

#
echo <<EOF
curl -s -k -H "Content-Type: application/json"     -H "Authorization: Bearer $TOKEN"     https://speech.googleapis.com/v1/operations/6152850171522197711 > Lewis-output.json
EOF