# Basic Deployment Example

This example demonstrates a basic deployment of the QuickSight Admin Dashboard.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your specific values:
   ```hcl
   region              = "us-east-1"
   cloudtrail_location = "your-cloudtrail-bucket/AWSLogs/123456789012/CloudTrail"
   start_date          = "2023/01/01"
   quicksight_admin_arn = "arn:aws:quicksight:us-east-1:123456789012:user/default/admin-username"
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Deploy the resources:
   ```bash
   terraform apply
   ```

## Requirements

- AWS account with appropriate permissions
- Terraform v1.0.0 or later
- CloudTrail enabled and logging to an S3 bucket
- QuickSight Enterprise subscription

## Notes

This example uses the default settings for Lambda functions and other resources. For more advanced configurations, see the other examples or refer to the main README.