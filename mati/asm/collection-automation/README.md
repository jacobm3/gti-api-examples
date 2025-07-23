load-asm-aws-integration.py configures AWS integrations in ASM.  You can configure a single integration with CLI options (-n, -a) or bulk load integrations from a CSV.

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
