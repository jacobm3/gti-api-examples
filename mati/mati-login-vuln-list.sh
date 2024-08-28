#!/bin/bash

# get session token
MTOKEN=".mandiant-token"
curl -s -X POST https://api.intelligence.mandiant.com/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->" \
  --data "grant_type=client_credentials" --user "gti-user:$GTIKEY" | jq -r .access_token > $MTOKEN

# do stuff
curl -s -X GET "https://api.intelligence.mandiant.com/v4/vulnerability" \
  -H "Authorization: Bearer $(cat $MTOKEN)" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->"

rm $MTOKEN
