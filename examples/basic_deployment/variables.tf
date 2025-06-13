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
  default     = "2023/01/01"
}

variable "quicksight_admin_arn" {
  description = "ARN of your QuickSight admin user"
  type        = string
}