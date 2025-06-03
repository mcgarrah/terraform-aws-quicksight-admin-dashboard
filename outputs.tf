output "glue_database_name" {
  description = "Name of the Glue database created for the QuickSight Admin Console"
  value       = aws_glue_catalog_database.admin_console.name
}

output "lambda_role_arn" {
  description = "ARN of the IAM role created for Lambda functions"
  value       = aws_iam_role.quicksight_admin_console.arn
}

output "s3_data_bucket" {
  description = "Name of the S3 bucket created for data storage"
  value       = aws_s3_bucket.data_storage.bucket
}

output "s3_lambda_code_bucket" {
  description = "Name of the S3 bucket created for Lambda code storage"
  value       = aws_s3_bucket.lambda_code.bucket
}

# These outputs will be expanded as more resources are created
# For example, QuickSight dashboard URL will be added later