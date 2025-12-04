API_KEY=$GTIKEY

curl -s -X GET \
"https://www.virustotal.com/api/v3/collections?filter=collection_type%3Areport%20name%3A%22OT%22%20origin%3A%22Google%20Threat%20Intelligence%22&order=creation_date-" \
-H "accept: application/json" \
-H "x-apikey: $API_KEY"  \
| jq '.data[] | {id: .id, name: .attributes.name}'

#"https://www.virustotal.com/api/v3/collections?filter=collection_type%3Areport%20name%3A%22OT%20Threat%22%20origin%3A%22Google%20Threat%20Intelligence%22&order=creation_date-" \
#| jq '.data[] | {id: .id, name: .attributes.name, executive_summary: .attributes.executive_summary}'

