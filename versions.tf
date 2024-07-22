terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }

  }
}

provider "aws" {
  shared_config_files      = var.config_file
  shared_credentials_files = var.creds_file
  profile                  = var.profile_01
  region                   = var.aws_region_01
}
