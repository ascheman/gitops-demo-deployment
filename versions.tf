terraform {
  required_version = "1.2.7"

  backend "s3" {
    // Make sure this has same prefix as the created bucket / Git repository url
    key = "aschemann-gitops-sample"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.33.0"
    }
  }
}
