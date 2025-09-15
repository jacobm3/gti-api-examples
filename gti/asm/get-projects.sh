#!/bin/bash

curl -s -X GET https://www.virustotal.com/api/v3/asm/projects \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "x-apikey: $GTIKEY" \

