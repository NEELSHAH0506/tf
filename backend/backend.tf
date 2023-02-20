
terraform {
  required_version = "=1.3.7"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.53.0"
    }
  }

  /* S3 Backend, disabled initially to create backend bucket */
  backend "s3" {
    bucket  = "intrro-tf-backend"
    region  = "eu-west-2"
    key     = "backend.tfstate"

    encrypt         = true
    kms_key_id      = "alias/tf-intrro-bucket-key"

    dynamodb_table  = "intrro-terraform-state"
  }
}

provider "aws" {
  region = var.aws_region
}
