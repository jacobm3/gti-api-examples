#!/usr/bin/env python3
#
# Scrapes ASM scan ranges from https://gtidocs.virustotal.com/docs/asm-scan-ranges
# Gemini / jmarts@google.com 
# 


import requests
import re
import json
import sys

def get_asm_ranges():
    url = "https://gtidocs.virustotal.com/docs/asm-scan-ranges"
    
    try:
        # 1. Fetch the webpage content
        response = requests.get(url)
        response.raise_for_status()  # Check for HTTP errors
        
        # 2. Define a regex pattern for IPs (e.g., 1.2.3.4) and CIDRs (e.g., 1.2.3.4/24)
        # Pattern explanation:
        # \d{1,3}       : 1 to 3 digits
        # \.            : a literal dot
        # (?:/\d{1,2})? : optional group matching a forward slash followed by 1-2 digits
        ip_pattern = r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?:/\d{1,2})?\b'
        
        # 3. Extract all matches from the text
        # We use a set to automatically remove duplicates, then convert back to a list
        ips = list(set(re.findall(ip_pattern, response.text)))
        
        # 4. Sort the list for cleaner output
        ips.sort()
        
        # 5. Output as JSON
        output = {
            "source": url,
            "count": len(ips),
            "ip_ranges": ips
        }
        
        print(json.dumps(output, indent=4))
        
    except requests.exceptions.RequestException as e:
        print(f"Error fetching the URL: {e}", file=sys.stderr)

if __name__ == "__main__":
    get_asm_ranges()
