#!/usr/bin/env python3

import requests
import os
import json

def get_asm_issues():
  """
  Fetches ASM issues with severity less than or equal to 2.

  Pulls makey, mskey, and asm_project_id from environment variables.

  Returns:
      str: JSON formatted string of the response data.
  """

  app_name = "<--APP NAME-->"  # Replace with your application name
  makey = os.environ.get("MAKEY")
  mskey = os.environ.get("MSKEY")
  asm_project_id = os.environ.get("ASM_PROJECT_ID")

  if not all([makey, mskey, asm_project_id]):
      raise ValueError("Missing environment variables: MAKEY, MSKEY, or ASM_PROJECT_ID")

  url = "https://asm-api.advantage.mandiant.com/api/v1/search/issues/severity_lte:2"
  headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "X-App-Name": app_name,
      "INTRIGUE_ACCESS_KEY": makey,
      "INTRIGUE_SECRET_KEY": mskey,
      "PROJECT_ID": asm_project_id,
  }

  response = requests.get(url, headers=headers)

  if response.status_code == 200:
    # Return the JSON data as a string
    return json.dumps(response.json(), indent=2)
  else:
    # Return an error message in JSON format
    return json.dumps({"error": f"Request failed with status code: {response.status_code}"}, indent=2)

# Example usage:
try:
  json_output = get_asm_issues()
  print(json_output)
except ValueError as e:
  print(json.dumps({"error": str(e)}, indent=2))
