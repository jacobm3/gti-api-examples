#!/bin/bash


# 
curl -s -X GET https://asm-api.advantage.mandiant.com/api/v1/search/issues/severity_lte:2  \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->" \
  -H "INTRIGUE_ACCESS_KEY: $MAKEY" \
  -H "INTRIGUE_SECRET_KEY: $MSKEY" \
  -H "PROJECT_ID: $ASM_PROJECT_ID" 

