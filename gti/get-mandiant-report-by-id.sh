#!/bin/bash
#
# Retrieves Mandiant report JSON by report ID.
#

REPORT="$1"
if [ -z "$REPORT" ]; then REPORT="24-10019694"; fi
if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

curl -s -H "x-apikey: $GTIKEY" https://www.virustotal.com/api/v3/mati/report/${REPORT} 
