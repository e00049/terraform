terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}

provider "aws" {
  profile = "dev"
  region  = "us-west-2"
  #   alias   = "dev-project"
}

#   provider      = aws.tf57-mumbai-production
provider "aws" {
  profile = "production"
  region  = "ap-south-1"
  alias   = "prod-project"
}

