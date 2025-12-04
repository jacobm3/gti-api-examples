#!/bin/bash
#
#

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

curl -s --request GET \
     --url https://www.virustotal.com/api/v3/collections?filter=collection_type:vulnerability%20name:CVE-2024 \
     --header "x-apikey: $GTIKEY" \
     --header 'accept: application/json'

