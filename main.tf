# QuickSight Admin Dashboard - Main Terraform Configuration

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Use the IAM module
module "iam" {
  source = "./modules/iam"
  
  role_name          = "QuickSightAdminConsole"
  policy_name        = "QuickSight-AdminConsole"
  policy_description = "Policy for QuickSight Admin Console Lambda functions"
  tags               = var.tags
}

# S3 bucket for Lambda code
resource "aws_s3_bucket" "lambda_code" {
  bucket = "admin-console-lambda-code-${data.aws_caller_identity.current.account_id}"
}

# S3 bucket for data storage
resource "aws_s3_bucket" "data_storage" {
  bucket = "admin-console-data-${data.aws_caller_identity.current.account_id}"
}

# S3 bucket policy for data storage
resource "aws_s3_bucket_policy" "data_storage" {
  bucket = aws_s3_bucket.data_storage.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = module.iam.role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.data_storage.arn,
          "${aws_s3_bucket.data_storage.arn}/*"
        ]
      }
    ]
  })
}

# Upload Lambda function code to S3
resource "aws_s3_object" "data_prepare_lambda" {
  bucket = aws_s3_bucket.lambda_code.bucket
  key    = "data_prepare.zip"
  source = "${path.module}/lambda/data_prepare.zip"
  etag   = filemd5("${path.module}/lambda/data_prepare.zip")
  
  depends_on = [aws_s3_bucket.lambda_code]
}

resource "aws_s3_object" "dataset_info_lambda" {
  bucket = aws_s3_bucket.lambda_code.bucket
  key    = "dataset_info.zip"
  source = "${path.module}/lambda/dataset_info.zip"
  etag   = filemd5("${path.module}/lambda/dataset_info.zip")
  
  depends_on = [aws_s3_bucket.lambda_code]
}

# Use the Lambda module for data preparation function
module "data_prepare_lambda" {
  source = "./modules/lambda"
  
  function_name = "QuickSightAdminConsole-DataPrepare"
  handler       = "data_prepare.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size
  role_arn      = module.iam.role_arn
  s3_bucket     = aws_s3_bucket.lambda_code.bucket
  s3_key        = aws_s3_object.data_prepare_lambda.key
  
  environment_variables = {
    S3_BUCKET = aws_s3_bucket.data_storage.bucket
  }
  
  tags = var.tags
}

# Use the Lambda module for dataset info function
module "dataset_info_lambda" {
  source = "./modules/lambda"
  
  function_name = "QuickSightAdminConsole-DatasetInfo"
  handler       = "dataset_info.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size
  role_arn      = module.iam.role_arn
  s3_bucket     = aws_s3_bucket.lambda_code.bucket
  s3_key        = aws_s3_object.dataset_info_lambda.key
  
  environment_variables = {
    S3_BUCKET = aws_s3_bucket.data_storage.bucket
  }
  
  tags = var.tags
}

# CloudWatch Event Rule to trigger data preparation Lambda function
resource "aws_cloudwatch_event_rule" "data_prepare_schedule" {
  name                = "QuickSightAdminConsole-DataPrepare-Schedule"
  description         = "Triggers the QuickSight Admin Console data preparation Lambda function"
  schedule_expression = "rate(1 day)"
}

# CloudWatch Event Target for data preparation Lambda function
resource "aws_cloudwatch_event_target" "data_prepare_target" {
  rule      = aws_cloudwatch_event_rule.data_prepare_schedule.name
  target_id = "QuickSightAdminConsole-DataPrepare"
  arn       = module.data_prepare_lambda.function_arn
}

# Lambda permission for CloudWatch Events
resource "aws_lambda_permission" "allow_cloudwatch_to_call_data_prepare" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.data_prepare_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data_prepare_schedule.arn
}

# Use the Athena module
module "athena" {
  source = "./modules/athena"
  
  database_name      = "admin-console"
  account_id         = data.aws_caller_identity.current.account_id
  s3_bucket          = aws_s3_bucket.data_storage.bucket
  cloudtrail_location = var.cloudtrail_location
}

# Use the QuickSight module
module "quicksight" {
  source = "./modules/quicksight"
  
  account_id           = data.aws_caller_identity.current.account_id
  admin_arn            = var.quicksight_admin_arn
  database_name        = module.athena.database_name
  group_membership_table = module.athena.group_membership_table
  user_info_table      = module.athena.user_info_table
  dashboard_info_table = module.athena.dashboard_info_table
  dataset_info_table   = module.athena.dataset_info_table
}