#!/bin/bash

curl -s -X GET https://asm-api.advantage.mandiant.com/api/v1/issues/610c6a33a65d209f6b4352890059925b7c42cad7e517bf2f7f54d67deb4577cf \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->" \
  -H "INTRIGUE_ACCESS_KEY: $MAKEY" \
  -H "INTRIGUE_SECRET_KEY: $MSKEY" 


