#!/bin/bash

# Easiest way to get working search strings is to search in the web UI and copy the resulting "search_string" 
# parameter from the browser address bar.
#
# For UI search parameter help, see https://docs.mandiant.com/home/asm-search-syntax
#
# Note: The "collection name" value expected in the API is not the same as shown in the UI. Use the name 
#       shown in the search_string from the address bar.
#
# API reference: https://docs.mandiant.com/home/asm-api
#

# new/open issues, after 9/1, from a specific collection
SEARCH_STR="status_new%3Aopen%20first_seen_after%3A2024-09-01%20collection%3Aseed_azureresourcegraphresults-query4_qlnhrx0"

# all issues first seen after a specific date
SEARCH_STR="first_seen_after%3A2024-09-09"

curl -s -X GET "https://asm-api.advantage.mandiant.com/api/v1/search/issues/${SEARCH_STR}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "INTRIGUE_ACCESS_KEY: $MAKEY" \
  -H "INTRIGUE_SECRET_KEY: $MSKEY" \
  -H "PROJECT_ID: $ASM_PROJECT_ID" 

