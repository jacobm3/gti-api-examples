#!/bin/bash
#
# note - URLs must be base64 encoded for submission
#

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

URL="$1"
if [ -z "$URL" ]; then URL="docs.google.com/drawings/d/1z_z_7I2eVf9ZmwBzEuPTIBRzDhMJmBYF0nWoPtkbE2c/edit"; fi

# VT API wants URL base64 encoded without any trailing padding
B64URL=$(echo -n "$URL" | base64 -w0 | sed 's/=//g')

curl -s --request GET \
  --url https://www.virustotal.com/api/v3/urls/${B64URL} \
  --header "x-apikey: $GTIKEY"
