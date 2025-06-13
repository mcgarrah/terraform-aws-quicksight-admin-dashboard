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
  
  validation {
    condition     = can(regex("^arn:aws:quicksight:[a-z0-9-]+:[0-9]{12}:user/default/.+$", var.quicksight_admin_arn))
    error_message = "The quicksight_admin_arn must be a valid QuickSight user ARN."
  }
}

variable "alert_email" {
  description = "Email address to receive alerts"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "The alert_email must be a valid email address."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    Project     = "QuickSight-Admin-Dashboard"
    Terraform   = "true"
    Security    = "High"
  }
}