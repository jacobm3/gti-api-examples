#!/usr/bin/env python3
#
# Delete Mandiant ASM seeds within a collection. Requires a text file
# list of seeds to delete, one seed per line.
#
# Note: ASM stores leading and trailing spaces entered on seeds.
#
# jmarts@google.com
#


import argparse
import json
import logging
import os
import requests
import sys

from pprint import pprint

# Set up argument parsing
parser = argparse.ArgumentParser(description="Delete seeds from a Mandiant Advantage collection.")
parser.add_argument("-c", "--collection-uuid", required=True, help="UUID of the collection")
parser.add_argument("-f", "--seed-file", required=True, help="File containing a list of seeds to delete (one per line)")
parser.add_argument("-d", "--debug", action="store_true", help="Enable debug logging")
parser.add_argument("-n", "--dry-run", action="store_true", help="Don't delete seeds")

args = parser.parse_args()

# Set up logging
if args.debug:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

# Get API keys from environment variables
MAKEY = os.environ.get("MAKEY")
MSKEY = os.environ.get("MSKEY")
ASM_PROJECT_ID = os.environ.get("ASM_PROJECT_ID")

if not MAKEY or not MSKEY or not ASM_PROJECT_ID:
    logging.error("MAKEY, MSKEY, and ASM_PROJECT_ID environment variables must be set.")
    exit(1)

# Get the current script path
script_path = os.path.abspath(__file__)

# Get the script arguments (excluding the script name itself)
script_args = " ".join(sys.argv[1:])

# Log the script path and arguments
logging.info(f"Running script: ASM_PROJECT_ID={ASM_PROJECT_ID} {script_path} {script_args}")

# Read seeds from file
seeds_to_delete = []
try:
    with open(args.seed_file, "r") as f:
        seeds_to_delete = [line.strip() for line in f if line.strip()]
        logging.debug(f"Seeds to delete: {seeds_to_delete}")
except FileNotFoundError:
    logging.error(f"Seed file not found: {args.seed_file}")
    exit(1)

# Construct the API request
url = f"https://asm-api.advantage.mandiant.com/api/v1/user_collections/{args.collection_uuid}/user_entities"
headers = {
    "Content-Type": "application/json",  # Changed to JSON for DELETE request
    "Accept": "application/json",
    "X-App-Name": "<--APP NAME-->",  # Replace with your app name
    "INTRIGUE_ACCESS_KEY": MAKEY,
    "INTRIGUE_SECRET_KEY": MSKEY,
    "PROJECT_ID": ASM_PROJECT_ID
}

# get seeds from this collection, so we can delete them by their ID
try:
    logging.debug(f"Request: {url}")
    #logging.debug(f"Request headers: {headers}")
    response = requests.get(url, headers=headers)
    data = response.json()

    '''
    Sample response.json():

    {'message': 'Collection entities retrieved!',
     'result': [{'claimed': False,
             'created_at': '2024-09-01T00:41:53.298Z',
             'details': None,
             'id': 4726210,
             'last_modified': None,
             'name': '1.2.3.4',
             'seed': True,
             'type': 'IpAddress',
             'updated_at': '2024-09-01T00:41:53.298Z'},
            {'claimed': False,
             'created_at': '2024-09-01T00:41:53.308Z',
             'details': None,
             'id': 4726211,
             'last_modified': None,
             'name': '1.2.3.5',
             'seed': True,
             'type': 'IpAddress',
             'updated_at': '2024-09-01T00:41:53.308Z'},
    '''

    # build a hash of seed IDs, indexed by seed name (IP address)
    # we need these IDs to delete the seeds from the collection
    seed_name_id_dict = {}
    for row in response.json()["result"]:
        seed_id = row["id"]
        seed_name = row["name"].rstrip().lstrip()
        seed_name_id_dict[seed_name] = row["id"]
        #logging.debug(f"seed {seed_id} {seed_name}")

    logging.debug(f"Existing seeds: seed_name_id_dict: {seed_name_id_dict}")


    deleted_seed_count = 0
    for seed in seeds_to_delete:
        # get seed_id
        try:
            logging.debug(f"Looking up ID for seed {seed}")
            seed_id = seed_name_id_dict[seed]
        except Exception as e:
            logging.error(f"Exception. Seed ID not found: {e}. Continuing.")
            continue
            #sys.exit(1)
        logging.debug(f"Deleting seed {seed}, id = {seed_id}.")

        # delete seed by id
        try:
            url = f"https://asm-api.advantage.mandiant.com/api/v1/entities/{seed_id}"
            if args.dry_run:
                logging.debug(f"Dry run seed delete request: {url}")
            #logging.debug(f"Request headers: {headers}")
            else:
                logging.debug(f"Seed delete request: {url}")
                response = requests.delete(url, headers=headers)
                if response.status_code >= 200 and response.status_code < 300:
                    logging.info(f"Deleted seed {seed}, id:{seed_id}")
                    deleted_seed_count += 1
            data = response.json()
        except requests.exceptions.RequestException as e:
            logging.error(f"Error: {e}")

    print(f"Deleted {deleted_seed_count} seeds.")

except requests.exceptions.RequestException as e:
    logging.error(f"Error: {e}")

#logging.info("Seed deletion complete.")
