# Terraform S3 Backend

Setting up S3 backend for Terraform.

Requirements:
* Terraform 1.3.7

Initialization:

```shell
terraform init

terraform plan --var-file ./tfvars/<env>.tfvars
terraform apply --var-file ./tfvars/<env>.tfvars
```

Migrating the state to the S3:

Add the backend configuration block to terraform configuration at [backend.tf](./backend.tf).
```terraform
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "<bucket name>"
    region         = "<aws region>"
    key            = "<kms key name or alias>"
    dynamodb_table = "<dynamodb table name>"
  }
}
```

You can include all the variables in the file or pass some of them in the cli in the 
command or as a file ([Partial Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration)).

```shell
terraform init \
  -backend-config="bucket=<s3 bucket name>" \
  -backend-config="key=<s3 file path>" \
  -backend-config="dynamodb_table=<dynamodb table name>" \
  -migrate-state    # To migrate backend state from local to S3
```

If you have 2 backends for the same script and want to change it without migration prompt, pass `-reconfigure` instead:
```shell
terraform init \
  ... \
  -reconfigure
```
