#!/bin/bash

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

curl -s --request GET \
  --url https://www.virustotal.com/api/v3/dtm/monitors/${1} \
  --header "x-apikey: $GTIKEY"
