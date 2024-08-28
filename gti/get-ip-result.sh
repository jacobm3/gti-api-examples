#!/bin/bash

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

IPADDR="$1"
if [ -z "$IPADDR" ]; then IPADDR="124.195.255.12"; fi

curl -s --request GET \
  --url https://www.virustotal.com/api/v3/ip_addresses/${IPADDR} \
  --header "x-apikey: $GTIKEY"
