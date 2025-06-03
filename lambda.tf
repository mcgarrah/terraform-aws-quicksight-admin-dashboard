# Lambda functions for QuickSight Admin Dashboard

# Data preparation Lambda function
resource "aws_lambda_function" "data_prepare" {
  function_name = "QuickSightAdminConsole-DataPrepare"
  role          = aws_iam_role.quicksight_admin_console.arn
  handler       = "data_prepare.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size
  
  # The S3 bucket and key will need to be updated once the Lambda code is uploaded
  s3_bucket     = aws_s3_bucket.lambda_code.bucket
  s3_key        = "data_prepare.zip"
  
  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.data_storage.bucket
    }
  }
  
  tags = var.tags
}

# Dataset information Lambda function
resource "aws_lambda_function" "dataset_info" {
  function_name = "QuickSightAdminConsole-DatasetInfo"
  role          = aws_iam_role.quicksight_admin_console.arn
  handler       = "dataset_info.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size
  
  # The S3 bucket and key will need to be updated once the Lambda code is uploaded
  s3_bucket     = aws_s3_bucket.lambda_code.bucket
  s3_key        = "dataset_info.zip"
  
  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.data_storage.bucket
    }
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
  arn       = aws_lambda_function.data_prepare.arn
}

# Lambda permission for CloudWatch Events
resource "aws_lambda_permission" "allow_cloudwatch_to_call_data_prepare" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_prepare.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data_prepare_schedule.arn
}

# Note: The actual Lambda function code will need to be uploaded to the S3 bucket
# This can be done using the aws_s3_object resource or as part of a deployment pipeline