# Secure Deployment Example

This example demonstrates a secure deployment of the QuickSight Admin Dashboard with enhanced security features.

## Security Features

- KMS encryption for sensitive data
- SNS notifications for alerts
- Input validation for critical parameters
- Enhanced IAM permissions following least privilege
- Email notifications for failures

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
   alert_email         = "admin@example.com"
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Deploy the resources:
   ```bash
   terraform apply
   ```

5. Confirm the SNS subscription by clicking the link in the email you receive.

## Requirements

- AWS account with appropriate permissions
- Terraform v1.0.0 or later
- CloudTrail enabled and logging to an S3 bucket
- QuickSight Enterprise subscription
- Valid email address for alerts

## Notes

This example includes additional security features beyond the basic deployment:

1. KMS key for encryption
2. SNS topic for notifications
3. Input validation
4. Enhanced security tags

For a simpler deployment, see the basic_deployment example.