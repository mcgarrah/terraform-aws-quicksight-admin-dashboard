# QuickSight Admin Dashboard - Terraform Implementation

This project provides a Terraform implementation of the Amazon QuickSight Admin Dashboard described in the AWS blog article [Measure the adoption of your Amazon QuickSight dashboards and view your BI portfolio in a single pane of glass](https://aws.amazon.com/blogs/business-intelligence/measure-the-adoption-of-your-amazon-quicksight-dashboards-and-view-your-bi-portfolio-in-a-single-pane-of-glass/) by Maitri Brahmbhatt, Balaji Selva Rajan, Ian Liao, Marcelo Coronel, and Ying Wang.

## Quickstart

Get up and running in minutes:

```bash
# 1. Clone the repository
git clone https://github.com/mcgarrah/terraform-aws-quicksight-admin-dashboard.git
cd terraform-aws-quicksight-admin-dashboard

# 2. Create terraform.tfvars with your values
cat > terraform.tfvars << EOF
region              = "us-east-1"
cloudtrail_location = "your-cloudtrail-bucket/AWSLogs/123456789012/CloudTrail"
start_date          = "2023/01/01"
quicksight_admin_arn = "arn:aws:quicksight:us-east-1:123456789012:user/default/admin-username"
EOF

# 3. Initialize and apply
terraform init
terraform apply
```

After deployment, access your QuickSight dashboard to view your admin metrics.

## Overview

This solution creates a comprehensive admin dashboard for Amazon QuickSight that provides visibility into:

- Dashboard usage metrics
- User activity
- Group memberships
- Dataset information
- Overall QuickSight adoption

The original solution was implemented using CloudFormation templates. This project converts those templates to Terraform resources for easier deployment and management.

## Architecture

The solution consists of the following components:

1. **Lambda Functions** - Process QuickSight data and store it in S3
2. **Athena Tables** - Query the processed data
3. **QuickSight Dashboard** - Visualize the data

![Architecture Diagram](glue-job-arch-1.png)

## Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0.0 or later
- CloudTrail enabled and logging to an S3 bucket
- QuickSight Enterprise subscription

## Usage

1. Clone this repository
2. Update the `terraform.tfvars` file with your specific values
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Plan the deployment:
   ```
   terraform plan -out=tfplan
   ```
5. Apply the configuration:
   ```
   terraform apply tfplan
   ```

## Configuration

Create a `terraform.tfvars` file with the following variables:

```hcl
region              = "us-east-1"
cloudtrail_location = "your-cloudtrail-bucket/AWSLogs/your-account-id/CloudTrail"
start_date          = "2023/01/01"
quicksight_admin_arn = "arn:aws:quicksight:us-east-1:your-account-id:user/default/admin-username"
```

## Customization

You can customize the solution by modifying the following files:

- `variables.tf` - Adjust default values or add new variables
- `lambda.tf` - Modify Lambda function configurations
- `athena.tf` - Customize Athena table schemas
- `quicksight.tf` - Adjust QuickSight resources

## Lambda Functions

The solution includes two Lambda functions:

1. **Data Preparation Function** - Collects QuickSight metadata and stores it in S3
2. **Dataset Information Function** - Processes dataset information

The Lambda function code is stored in the `lambda` directory and deployed to S3 during the Terraform apply process.

## Enhanced Features

This implementation includes several enhancements beyond the base functionality:

### Security Enhancements
- **Least Privilege IAM Permissions**: Fine-grained IAM policies following security best practices
- **S3 Bucket Encryption**: Server-side encryption for all S3 buckets
- **S3 Bucket Versioning**: Version control for S3 objects to prevent accidental deletion
- **Input Validation**: Terraform variable validation for critical inputs

### Monitoring and Alerting
- **CloudWatch Alarms**: Automated monitoring of Lambda function errors
- **SNS Notifications**: Failure notifications for critical components

### Data Management
- **S3 Lifecycle Policies**: Automated management of data retention and transitions
- **Improved Error Handling**: Enhanced error handling in Lambda functions

## Troubleshooting

### Common Issues

1. **CloudTrail Location Not Found**
   - Verify your CloudTrail bucket exists and contains logs
   - Check the path format in `terraform.tfvars`

2. **QuickSight Permissions**
   - Ensure your QuickSight admin user has appropriate permissions
   - Verify the ARN format in `terraform.tfvars`

3. **Lambda Function Failures**
   - Check CloudWatch Logs for detailed error messages
   - Verify IAM permissions for the Lambda execution role

### Getting Help

If you encounter issues:
1. Check the CloudWatch Logs for error messages
2. Review the [TODO.md](TODO.md) file for known limitations
3. Open an issue on GitHub with detailed information about your problem

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original AWS blog authors: Maitri Brahmbhatt, Balaji Selva Rajan, Ian Liao, Marcelo Coronel, and Ying Wang
- AWS CloudFormation templates from the original blog post