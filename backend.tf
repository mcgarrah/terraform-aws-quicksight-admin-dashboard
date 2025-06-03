# This file contains the backend configuration for Terraform state management
# Uncomment and configure these settings to use remote state storage

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-quicksight-admin"
#     key            = "quicksight-admin/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }

# To create the required resources for the backend:
# 
# 1. Create an S3 bucket:
#    aws s3api create-bucket --bucket terraform-state-quicksight-admin --region us-east-1
#
# 2. Enable versioning on the S3 bucket:
#    aws s3api put-bucket-versioning --bucket terraform-state-quicksight-admin --versioning-configuration Status=Enabled
#
# 3. Create a DynamoDB table for state locking:
#    aws dynamodb create-table \
#      --table-name terraform-locks \
#      --attribute-definitions AttributeName=LockID,AttributeType=S \
#      --key-schema AttributeName=LockID,KeyType=HASH \
#      --billing-mode PAY_PER_REQUEST \
#      --region us-east-1