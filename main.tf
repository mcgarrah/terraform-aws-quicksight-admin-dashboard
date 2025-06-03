# QuickSight Admin Dashboard - Main Terraform Configuration

# IAM Role for QuickSight Admin Console
resource "aws_iam_role" "quicksight_admin_console" {
  name = "QuickSightAdminConsole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for QuickSight Admin Console
resource "aws_iam_policy" "quicksight_admin_console" {
  name        = "QuickSight-AdminConsole"
  description = "Policy for QuickSight Admin Console Lambda functions"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:*",
          "quicksight:*",
          "lambda:*",
          "s3:*",
          "sts:AssumeRole",
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "quicksight_admin_console" {
  role       = aws_iam_role.quicksight_admin_console.name
  policy_arn = aws_iam_policy.quicksight_admin_console.arn
}

# S3 bucket for Lambda code
resource "aws_s3_bucket" "lambda_code" {
  bucket = "admin-console-lambda-code-${data.aws_caller_identity.current.account_id}"
}

# S3 bucket for data storage
resource "aws_s3_bucket" "data_storage" {
  bucket = "admin-console-data-${data.aws_caller_identity.current.account_id}"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Glue Database
resource "aws_glue_catalog_database" "admin_console" {
  name = "admin-console"
}

# Note: The Lambda functions and QuickSight resources will be implemented in separate files
# This is a starting point for the infrastructure