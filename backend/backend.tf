
terraform {
  required_version = "=1.3.7"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.53.0"
    }
  }

  /* S3 Backend, disabled initially to create backend bucket */
#  backend "s3" {
#    encrypt = true
##    bucket  = "<bucket name>"
##    region  = "<aws region>"
##    key     = "<kms key name or alias>"
##    dynamodb_table = "<dynamodb table name>"
#  }
}

provider "aws" {
  region = var.aws_region
}
