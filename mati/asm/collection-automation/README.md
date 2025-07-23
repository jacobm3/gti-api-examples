# Bulk Configuring AWS Integrations
load-asm-aws-integration.py configures AWS integrations in ASM.  You can configure a single integration with CLI options (-n, -a) or bulk load integrations from a CSV. I recommend running in verbose mode (-v). Application logs are printed to STDOUT and captured to `asm_integration.log`. 


# Usage
`./load-asm-aws-integration.py --help`

```
$ ./load-asm-aws-integration.py  --help
2025-07-23 15:16:49 - INFO - Logging system initialized.
usage: load-asm-aws-integration.py [-h] -p PROJECT_ID [-n NAME] [-a ARN] [-f FILE] [-w WORKFLOW] [-d] [-v]

Load AWS integrations in ASM, one integration per collection. Steps: 1. Create new collection 2. Create new integration 3. Link
integration to collection

options:
  -h, --help            show this help message and exit
  -p PROJECT_ID, --project-id PROJECT_ID
                        Existing ASM integer project ID. ex: 24020
  -n NAME, --name NAME  Name of the collection to create
  -a ARN, --arn ARN     Full ARN of the existing Mandiant ASM role in AWS. ex: arn:aws:iam::7501232456:role/Mandiant-ASM-Access
  -f FILE, --file FILE  Path to CSV containing ARN,Name for bulk creation. Columns: collection_name, role_arn
  -w WORKFLOW, --workflow WORKFLOW
                        Workflow type. Default: "authenticated_cloud_discovery". Reference: https://docs.mandiant.com/home/asm-
                        create-a-collection#scan-workflow-templates
  -d, --dry-run         Dry run. Only print API calls.
  -v, --verbose         Increase output verbosity.
```

Example application log:
```
2025-01-22 13:36:55 - INFO - Logging system initialized.
2025-01-22 13:52:02 - INFO - Logging system initialized.
2025-01-22 13:52:02 - INFO - Running as: ./load-asm-aws-integration.py -p 25241 -f prod-accounts.csv -v
2025-01-22 13:52:02 - INFO - Starting.
2025-01-22 13:52:02 - DEBUG - Reading prod-accounts.csv
2025-01-22 13:52:02 - DEBUG - setup_single_collection_integration(name=PROD-TEX-01, arn=arn:aws:iam::123456789:role/Mandiant-ASM-Access)
2025-01-22 13:52:03 - DEBUG - POST https://asm-api.advantage.mandiant.com/api/v1/user_collections
2025-01-22 13:52:03 - DEBUG - Data: {'name': 'PROD-TEX-01', 'workflow_name': 'authenticated_cloud_discovery'}
2025-01-22 13:52:03 - DEBUG - Starting new HTTPS connection (1): asm-api.advantage.mandiant.com:443
2025-01-22 13:52:04 - DEBUG - https://asm-api.advantage.mandiant.com:443 "POST /api/v1/user_collections HTTP/1.1" 200 None
2025-01-22 13:52:04 - INFO - Collection created successfully!
```

