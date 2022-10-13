terraform {
  required_version = ">= 1.3.0"
  cloud {
    organization = "cklewar"

    workspaces {
      name = "f5-xc-uc-aws-azure-gcp-lab-module"
    }
  }

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.14"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}
