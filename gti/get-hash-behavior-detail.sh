#!/bin/bash

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

HASH="$1"
if [ -z "$HASH" ]; then HASH="131ae13512a7931484b5e53e1ec92031d6ae014c947e82deaab4e742350d7c42"; fi

curl -s --request GET \
  --url https://www.virustotal.com/api/v3/files/${HASH}/behaviour_summary \
  --header "x-tool: curl" \
  --header "x-apikey: $GTIKEY"
