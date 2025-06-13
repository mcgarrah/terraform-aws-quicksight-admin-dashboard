# Secure deployment example for QuickSight Admin Dashboard

provider "aws" {
  region = var.region
}

# Create KMS key for encryption
resource "aws_kms_key" "quicksight_admin" {
  description             = "KMS key for QuickSight Admin Dashboard"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  
  tags = var.tags
}

resource "aws_kms_alias" "quicksight_admin" {
  name          = "alias/quicksight-admin-dashboard"
  target_key_id = aws_kms_key.quicksight_admin.key_id
}

# Create SNS topic for notifications
resource "aws_sns_topic" "quicksight_admin_alerts" {
  name = "quicksight-admin-dashboard-alerts"
  kms_master_key_id = aws_kms_key.quicksight_admin.id
}

# Subscribe to the SNS topic
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.quicksight_admin_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

module "quicksight_admin_dashboard" {
  source = "../../"
  
  # Required variables
  cloudtrail_location = var.cloudtrail_location
  start_date          = var.start_date
  quicksight_admin_arn = var.quicksight_admin_arn
  
  # Enhanced security settings
  lambda_runtime     = "python3.12"
  lambda_timeout     = 300
  lambda_memory_size = 256
  
  tags = var.tags
}