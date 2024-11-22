#!/usr/bin/env python3
#
# Create a single ASM collection and AWS integration or bulk load
# from a CSV file.
#
# jmarts@google.com
#

import argparse
import csv
import datetime
import json
import logging
import requests
import os
import sys
import time

from pprint import pprint

# Configure logging
def custom_time(*args):
    dt = datetime.datetime.now()
    return dt.isoformat(sep=' ', timespec='milliseconds')

logging.basicConfig(
    filename='asm_integration.log',
    level=logging.DEBUG,
    format='%(custom_time)s - %(levelname)s - %(message)s'
)

logging.Formatter.converter = custom_time

#logging.basicConfig(
#    filename='asm_integration.log',
#    level=logging.DEBUG,
#    format='%(asctime)s.%(msecs)03d%(timezone)s - %(levelname)s - %(message)s',
#    datefmt='%Y-%m-%dT%H:%M:%S',
#)

# Create a handler to output to stdout as well
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)  # Set the level for console output
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
console_handler.setFormatter(formatter)
logging.getLogger().addHandler(console_handler) 

def get_headers(makey, mskey, project_id):
    """Returns the headers for ASM API requests."""
    return {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "INTRIGUE_ACCESS_KEY": makey,
        "INTRIGUE_SECRET_KEY": mskey,
        "PROJECT_ID": str(project_id),
    }


def create_integration(headers, project_uuid, name, role_arn):
    """Creates an integration in ASM."""

    url = f"https://asm-api.advantage.mandiant.com/api/v1/projects/{project_uuid}/integrations"
    data = {"name": name, "secrets": {"aws_role_arn": role_arn}, "type": "AwsCredential"}

    logging.debug(f"POST {url}")
    logging.debug(f"Data: {data}")

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 200:
        logging.info("Integration created successfully!")
        logging.debug(f"Response: {response.json()}")
        return(response.json())
    else:
        logging.error(f"Error creating integration: {response.status_code}")
        logging.error(f"Response: {response.text}")
        sys.exit(1)

    return response.text


def create_user_collection(headers, name, workflow_name):
    """Creates a user collection in ASM."""

    url = "https://asm-api.advantage.mandiant.com/api/v1/user_collections"
    data = {"name": name, "workflow_name": workflow_name}

    logging.debug(f"POST {url}")
    logging.debug(f"Data: {data}")

    if args.dry_run:
        return
    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 200:
        logging.info("Collection created successfully!")
        logging.debug(f"Response: {response.json()}")
        return(response.json())
    else:
        logging.error(f"Error creating collection: {response.status_code}")
        logging.error(f"Response: {response.text}")
        sys.exit(1)


def link_collection_integration(headers, collection_uuid, integration_uuid):
    """Links an integration to a collection in ASM."""

    url = f"https://asm-api.advantage.mandiant.com/api/v1/user_collections/{collection_uuid}/integration_collections"
    data = {"integration_uuid": integration_uuid}

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 200:
        logging.info("Collection linked successfully!")
        logging.debug(f"Response: {response.json()}")
        return(response.json())
    else:
        logging.error(f"Error linking collection: {response.status_code}")
        logging.error(f"Response: {response.text}")
        sys.exit(1)


def setup_single_collection_integration(name, arn):
    """Creates an ASM collection and an integration, then links them."""
    
    workflow = args.workflow
    logging.debug(f"setup_single_collection_integration(name={name}, arn={arn}")
    collection = create_user_collection(headers, name, workflow)
    
    if args.dry_run:
        return

    project_uuid = collection['result']['project_uuid']
    collection_uuid = collection['result']['uuid']

    integration = create_integration(headers=headers, project_uuid=project_uuid, name=name, role_arn=arn)
    integration_uuid = integration['result']['uuid']

    link = link_collection_integration(headers=headers, collection_uuid=collection_uuid, integration_uuid=integration_uuid)
    

def read_csv(file_path):
    """Reads a CSV file using the csv library and processes each row."""

    logging.debug(f"Reading {file_path}")
    with open(file_path, 'r') as file:
        reader = csv.reader(file)

        for row in reader:
            # expects the ARN in the 2nd CSV column, and Name in the 4th column
            # indexed from zero
            setup_single_collection_integration(name=row[3], arn=row[1])


def main():
    """Parses command-line arguments and high level flow control."""

    parser = argparse.ArgumentParser(description="Load AWS integrations in ASM.")
    parser.add_argument( "-p", "--project-id", required=True, type=int, help="ASM Project ID")
    parser.add_argument("-n", "--name", help="Name of the collection")
    parser.add_argument("-a", "--arn", help="Name of the Mandiant ASM role in AWS")
    parser.add_argument("-f", "--file", help="Path to CSV containing ARN,Name for bulk creation")
    parser.add_argument( "-w", "--workflow", 
        default="authenticated_cloud_discovery",
        help="Workflow name (e.g., external_discovery_and_assessment)",
    )
    parser.add_argument("-d", "--dry-run", action="store_true", default=False, 
        help="Dry run. Only print API calls."
    )
    parser.add_argument("-v", "--verbose", action="store_true", default=False, 
        help="Increase output verbosity."
    ) 

    global args
    args = parser.parse_args()

    # Set logging level based on verbose flag
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
        console_handler.setLevel(logging.DEBUG) 
    else:
        logging.getLogger().setLevel(logging.INFO)
        console_handler.setLevel(logging.INFO)

    if args.dry_run:
        logging.info("Starting dry run.")
    else:
        logging.info("Starting.")

    makey = os.environ.get("MAKEY")
    mskey = os.environ.get("MSKEY")

    global headers
    headers = get_headers(makey, mskey, args.project_id)

    if not makey or not mskey:
        logging.error("Error: MAKEY and MSKEY environment variables must be set.")
        exit(1)


    if not ((args.name and args.arn) or args.file):
        parser.error("You must provide (NAME and ARN) or FILE pointing to a CSV containing names and ARNs.")

    # Check for mutually exclusive arguments
    if (args.name or args.arn) and args.file:
        parser.error("You cannot provide both (--name and/or --arn) and --file at the same time.")

    # single run
    elif args.name and args.arn:
        setup_single_collection_integration(name=args.name, arn=args.arn)

    # bulk run from csv
    elif args.file:
        read_csv(args.file)

if __name__ == "__main__":
    main()
