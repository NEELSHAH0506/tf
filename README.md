# Intrro-Infra

Terraform script for managing **Intrro** infrastructure.

Requirements:
- Terraform 1.3.7
- AWS access

## Project Structure

```
.
├── account
│   ├── tfvars/
│   │   └── <env>.tfvars
│   ├── backend.tf
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── <stack-name>
│   ├── tfvars/
│   │   └── <env>.tfvars
│   ├── backend.tf
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
└── modules
    ├── <module-0-name>
    │   ├── main.tf
    │   ├── output.tf
    │   └── variables.tf
    └── <module-1-name>
        ├── main.tf
        ├── output.tf
        └── variables.tf
```

Root level directory descriptions:

`account/` contains account wide infrastructure descriptions that all other stacks
will share and depend on. Such as VPC, S3, or Route53 resources.

`<stack-name>/` contains terraform script for specific stack. Such as different backend applications,
pipeline resources, or else.

`modules/` contains reusable terraform modules that can be used by any top level modules.

Other directories:

`tfvars/` contains terraform variable declarations for each environment (`<env>`).

## Backend configuration

We use S3 backend for the terraform backend. Backend is used to track changes made by terraform and compare
it to the actual infrastructure (more: [Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)).
S3 bucket is used to store terraform state file to enable secure storage and collaboration.

It is important that no 2 terraform tasks are changing the state at the same time. For that we can enable
state locking using a DynamoDB table.
- [More one S3 backend configuration](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
