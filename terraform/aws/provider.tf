provider "aws" {
  region = local.region

  default_tags {
    tags = local.tags
  }
}

terraform {
  backend "s3" {
    bucket = "optica-tf-state"
    key    = "ibkr-client-portal-api/state-managed.tfstate"
    region = "us-west-2"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  required_version = ">= 0.14.9"
}

data "terraform_remote_state" "infra-core" {
  backend = "s3"
  config = {
    bucket = "optica-tf-state"
    key    = "infrastructure-core/state-managed.tfstate"
    region = "us-west-2"
  }
}
