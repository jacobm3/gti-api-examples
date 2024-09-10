#!/bin/bash

ASM_PROJECT_ID=24022

curl -s -X GET https://asm-api.advantage.mandiant.com/api/v1/user_collections/${1} \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->" \
  -H "INTRIGUE_ACCESS_KEY: $MAKEY" \
  -H "INTRIGUE_SECRET_KEY: $MSKEY" \
  -H "PROJECT_ID: $ASM_PROJECT_ID" 

