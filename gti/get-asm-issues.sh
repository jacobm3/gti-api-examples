#!/bin/bash

#  https://gtidocs.virustotal.com/reference/get_search-issues-search-string 
#      --url https://www.virustotal.com/api/v3/asm/search/issues/search_string \
# 
# the easiest way to obtain "search_string" is to construct the search in the UI,
# then copy the 
#
# ex: https://asm.advantage.mandiant.com/issues?table_view=false&grouped_by=none&search_string=last_seen_after%3Aconfigured_scan_count%20severity%3A2%20status_new%3Aopen

# copy the text after "search_string=" and append that after /issues/:
# --url https://www.virustotal.com/api/v3/asm/search/issues/category%3Avulnerability%20first_seen_after%3A2023-01-01 

curl -s --request GET \
     --url https://www.virustotal.com/api/v3/asm/search/issues/category%3Avulnerability%20first_seen_after%3A2023-01-01  \
     --header "x-apikey: $GTIKEY" \
     --header 'accept: application/json'

     #--header "PROJECT-ID: $PROJECT" \
