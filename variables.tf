variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cloudtrail_location" {
  description = "Location of your CloudTrail logs in S3, without s3:// prefix"
  type        = string
}

variable "start_date" {
  description = "Start date for the data in the CloudTrail bucket in YYYY/MM/DD format"
  type        = string
}

variable "quicksight_admin_arn" {
  description = "ARN of your QuickSight admin user (e.g., arn:aws:quicksight:us-east-1:accountid:user/default/admin)"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
  default     = "python3.9"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda functions in seconds"
  type        = number
  default     = 300
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda functions in MB"
  type        = number
  default     = 128
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Project     = "QuickSight-Admin-Dashboard"
    Environment = "Production"
    Terraform   = "true"
  }
}