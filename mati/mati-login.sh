#!/bin/bash

# get session token
MTOKEN=".mandiant-token"
curl -s -X POST https://api.intelligence.mandiant.com/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->" \
  --data "grant_type=client_credentials" --user "gti-user:$GTIKEY" | jq -r .access_token > $MTOKEN

