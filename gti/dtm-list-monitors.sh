#!/bin/bash

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

DOMAIN="$1"
if [ -z "$DOMAIN" ]; then DOMAIN="serak.top"; fi

curl -s --request GET \
  --url https://www.virustotal.com/api/v3/dtm/monitors \
  --header "x-apikey: $GTIKEY"
