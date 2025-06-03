terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  # Uncomment this block to use Terraform Cloud for state management
  # backend "remote" {
  #   organization = "your-organization"
  #   
  #   workspaces {
  #     name = "quicksight-admin-dashboard"
  #   }
  # }
}

provider "aws" {
  region = var.region
  
  # Uncomment if you need to assume a role
  # assume_role {
  #   role_arn = "arn:aws:iam::123456789012:role/TerraformExecutionRole"
  # }
  
  default_tags {
    tags = var.tags
  }
}