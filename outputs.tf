output "glue_database_name" {
  description = "Name of the Glue database created for the QuickSight Admin Console"
  value       = module.athena.database_name
}

output "lambda_role_arn" {
  description = "ARN of the IAM role created for Lambda functions"
  value       = module.iam.role_arn
}

output "s3_data_bucket" {
  description = "Name of the S3 bucket created for data storage"
  value       = aws_s3_bucket.data_storage.bucket
}

output "s3_lambda_code_bucket" {
  description = "Name of the S3 bucket created for Lambda code storage"
  value       = aws_s3_bucket.lambda_code.bucket
}

output "data_prepare_lambda_arn" {
  description = "ARN of the data preparation Lambda function"
  value       = module.data_prepare_lambda.function_arn
}

output "dataset_info_lambda_arn" {
  description = "ARN of the dataset information Lambda function"
  value       = module.dataset_info_lambda.function_arn
}

output "quicksight_data_source_arn" {
  description = "ARN of the QuickSight data source"
  value       = module.quicksight.data_source_arn
}

output "quicksight_dashboard_url" {
  description = "URL of the QuickSight dashboard"
  value       = module.quicksight.dashboard_url
}