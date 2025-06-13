# CloudWatch Alarms and SNS Notifications for QuickSight Admin Dashboard

# SNS Topic for alarm notifications
resource "aws_sns_topic" "lambda_alarms" {
  name = "quicksight-admin-dashboard-alarms"
}

# CloudWatch Alarm for Data Preparation Lambda errors
resource "aws_cloudwatch_metric_alarm" "data_prepare_errors" {
  alarm_name          = "QuickSightAdminConsole-DataPrepare-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm monitors errors in the QuickSight Admin Console data preparation Lambda function"
  
  dimensions = {
    FunctionName = module.data_prepare_lambda.function_name
  }
  
  alarm_actions = [aws_sns_topic.lambda_alarms.arn]
  ok_actions    = [aws_sns_topic.lambda_alarms.arn]
}

# CloudWatch Alarm for Dataset Info Lambda errors
resource "aws_cloudwatch_metric_alarm" "dataset_info_errors" {
  alarm_name          = "QuickSightAdminConsole-DatasetInfo-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This alarm monitors errors in the QuickSight Admin Console dataset info Lambda function"
  
  dimensions = {
    FunctionName = module.dataset_info_lambda.function_name
  }
  
  alarm_actions = [aws_sns_topic.lambda_alarms.arn]
  ok_actions    = [aws_sns_topic.lambda_alarms.arn]
}

# CloudWatch Dashboard for monitoring
resource "aws_cloudwatch_dashboard" "quicksight_admin" {
  dashboard_name = "QuickSightAdminConsole-Monitoring"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", module.data_prepare_lambda.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", module.data_prepare_lambda.function_name],
            ["AWS/Lambda", "Duration", "FunctionName", module.data_prepare_lambda.function_name]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "Data Preparation Lambda Metrics"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", module.dataset_info_lambda.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", module.dataset_info_lambda.function_name],
            ["AWS/Lambda", "Duration", "FunctionName", module.dataset_info_lambda.function_name]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "Dataset Info Lambda Metrics"
        }
      }
    ]
  })
}