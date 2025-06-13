variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "QuickSightAdminConsole"
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = "QuickSight-AdminConsole"
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = "Policy for QuickSight Admin Console Lambda functions"
}

variable "tags" {
  description = "Tags to apply to the IAM resources"
  type        = map(string)
  default     = {}
}

# IAM Role for QuickSight Admin Console
resource "aws_iam_role" "this" {
  name = var.role_name
  
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
  
  tags = var.tags
}

# IAM Policy for QuickSight Admin Console
resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "quicksight:List*",
          "quicksight:Describe*",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
  
  tags = var.tags
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}

output "policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.this.arn
}