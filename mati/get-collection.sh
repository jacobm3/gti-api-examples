#!/bin/bash

MTOKEN=".mandiant-token"

# do stuff
curl -s -X GET "https://api.intelligence.mandiant.com/v4/vulnerability" \
  -H "Authorization: Bearer $(cat $MTOKEN)" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->"

rm $MTOKEN
