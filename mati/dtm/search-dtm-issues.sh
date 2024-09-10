#!/bin/bash
#
# Search DTM issues
#
# API docs:
#   https://docs.mandiant.com/home/dtm-using-the-dtm-api
#   https://docs.mandiant.com/home/digital-threat-monitoring-api#tag/Alerts/operation/get-alerts
#

# get session token
MTOKEN=".mandiant-token"
curl -s -X POST https://api.intelligence.mandiant.com/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  -H "X-App-Name: <--APP NAME-->" \
  --data "grant_type=client_credentials" --user "gti-user:$GTIKEY" | jq -r .access_token > $MTOKEN

# Search filter
# Max size is 25.  Must use pagination beyond that.
SEARCH_STR="size=25&since=2024-09-10T21:00:00Z"
curl -s -X GET "https://api.intelligence.mandiant.com/v4/dtm/alerts?${SEARCH_STR}" \
  -H "Authorization: Bearer $(cat $MTOKEN)" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" 
