#!/bin/bash

if [ -z "$GTIKEY" ]; then echo "GTIKEY is missing"; exit 1; fi

curl -s --request GET \
  --url https://www.virustotal.com/api/v3/dtm/settings/domains/txt_record \
  --header "x-apikey: $GTIKEY"

# example output
#  $ ./dtm-get-all-domain-verification-codes.sh | egrep 'mandiant|google'
#  2024-08-08T16:41:16.139217424Z,googleguy.app,unverified,dtm-domain-verification=UmRsA2WwOE5uUDsJj4jTYw5NV8xadYQ2GQFWILzTlJc
#  2024-05-21T18:30:00.49902956Z,mandiant.com,unverified,dtm-domain-verification=62GOeYHYmzToacLAULpBiPn2gJ9-p-w_oO4HISY2CRc
#  2024-04-26T14:33:34.117460533Z,google.com,unverified,dtm-domain-verification=iM8uxPFJPq9NjVRi2iNTUgkvZjyn_RdcNFjBFhJNVfg
