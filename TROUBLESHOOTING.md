# Troubleshooting Guide for QuickSight Admin Dashboard

This guide provides solutions for common issues you might encounter when deploying or using the QuickSight Admin Dashboard.

## Deployment Issues

### Error: Invalid QuickSight Admin ARN

**Symptom:** Terraform plan/apply fails with an error about invalid QuickSight admin ARN.

**Solution:**
1. Verify your QuickSight admin ARN follows the format: `arn:aws:quicksight:region:account-id:user/default/username`
2. Ensure the user exists in your QuickSight account
3. Check that you have the correct AWS account ID in the ARN

### Error: S3 Bucket Already Exists

**Symptom:** Terraform fails to create S3 buckets because they already exist.

**Solution:**
1. Use a different bucket name by modifying the code in `main.tf`
2. Import the existing bucket into your Terraform state:
   ```
   terraform import aws_s3_bucket.lambda_code bucket-name
   ```
3. Delete the existing bucket if it's not in use

### Error: CloudTrail Location Not Found

**Symptom:** Lambda functions fail to process CloudTrail data.

**Solution:**
1. Verify your CloudTrail is enabled and logging to S3
2. Check the path format in `terraform.tfvars` (should be `bucket-name/AWSLogs/account-id/CloudTrail`)
3. Ensure your IAM role has permissions to access the CloudTrail bucket

## Lambda Function Issues

### Error: Lambda Function Timeouts

**Symptom:** Lambda functions time out during execution.

**Solution:**
1. Increase the Lambda timeout in `variables.tf`:
   ```hcl
   variable "lambda_timeout" {
     description = "Timeout for Lambda functions in seconds"
     type        = number
     default     = 600  # Increase from 300 to 600
   }
   ```
2. Consider optimizing the Lambda code to process data more efficiently

### Error: Lambda Function Memory Errors

**Symptom:** Lambda functions fail with out-of-memory errors.

**Solution:**
1. Increase the Lambda memory size in `variables.tf`:
   ```hcl
   variable "lambda_memory_size" {
     description = "Memory size for Lambda functions in MB"
     type        = number
     default     = 256  # Increase from 128 to 256
   }
   ```

### Error: Permission Denied

**Symptom:** Lambda functions fail with permission denied errors.

**Solution:**
1. Check the IAM role permissions in `modules/iam/main.tf`
2. Ensure the role has necessary permissions for QuickSight, S3, and CloudWatch
3. Verify that your QuickSight admin user has appropriate permissions

## QuickSight Dashboard Issues

### Error: Dashboard Not Showing Data

**Symptom:** QuickSight dashboard is created but shows no data.

**Solution:**
1. Check if Lambda functions executed successfully (CloudWatch Logs)
2. Verify that data was written to S3 (check S3 bucket)
3. Ensure Athena tables were created and contain data
4. Check QuickSight dataset permissions

### Error: QuickSight Dataset Refresh Failures

**Symptom:** QuickSight datasets fail to refresh.

**Solution:**
1. Check if the S3 data location is accessible to QuickSight
2. Verify that the Athena database and tables exist
3. Ensure the QuickSight service role has appropriate permissions

## Monitoring and Alerting

### Error: Missing CloudWatch Alarms

**Symptom:** CloudWatch alarms are not triggering for Lambda errors.

**Solution:**
1. Verify that the CloudWatch alarms were created in `monitoring.tf`
2. Check that the SNS topic was created and has appropriate permissions
3. Ensure you have subscribed to the SNS topic to receive notifications

## Getting Help

If you continue to experience issues:

1. Check CloudWatch Logs for detailed error messages
2. Review the [TODO.md](TODO.md) file for known limitations
3. Open an issue on GitHub with:
   - Detailed description of the problem
   - Error messages
   - Terraform version
   - AWS provider version
   - Steps to reproduce