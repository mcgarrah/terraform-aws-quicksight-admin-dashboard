# Basic deployment example for QuickSight Admin Dashboard

provider "aws" {
  region = var.region
}

module "quicksight_admin_dashboard" {
  source = "../../"
  
  # Required variables
  cloudtrail_location = var.cloudtrail_location
  start_date          = var.start_date
  quicksight_admin_arn = var.quicksight_admin_arn
  
  # Optional variables with defaults
  lambda_runtime     = "python3.12"
  lambda_timeout     = 300
  lambda_memory_size = 128
  
  tags = {
    Environment = "Demo"
    Project     = "QuickSight-Admin-Dashboard"
    Terraform   = "true"
  }
}