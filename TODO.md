# QuickSight Admin Dashboard - Terraform Implementation Plan

This document outlines the plan to convert the AWS CloudFormation templates from the [AWS Blog article](https://aws.amazon.com/blogs/business-intelligence/measure-the-adoption-of-your-amazon-quicksight-dashboards-and-view-your-bi-portfolio-in-a-single-pane-of-glass/) into Terraform resources.

## Project Overview

The goal is to create a Terraform implementation of the QuickSight Admin Dashboard that provides visibility into QuickSight usage and adoption metrics. The solution will collect and analyze data about QuickSight dashboards, users, and usage patterns.

## Architecture Components

1. **IAM Roles and Policies** - For Lambda functions and other services
2. **Lambda Functions**:
   - Data preparation function
   - Dataset information function
3. **Athena Database and Tables** - For storing and querying QuickSight usage data
4. **QuickSight Resources**:
   - Data source
   - Datasets
   - Analysis
   - Dashboard

## Implementation Tasks

### 1. Project Structure Setup
- [x] Create initial project structure
- [ ] Set up provider configuration
- [ ] Create variables.tf for configurable parameters
- [ ] Create outputs.tf for important resource outputs

### 2. IAM Resources
- [ ] Create IAM role for Lambda functions with appropriate permissions
- [ ] Create service-linked roles if needed

### 3. Lambda Functions
- [ ] Extract and analyze Lambda function code from the CloudFormation templates
- [ ] Create Lambda function resources in Terraform
- [ ] Set up Lambda environment variables
- [ ] Configure Lambda triggers and permissions

### 4. S3 Buckets
- [ ] Create S3 bucket for storing Lambda code
- [ ] Create S3 bucket for CloudTrail logs (if needed)
- [ ] Set up appropriate bucket policies

### 5. Athena Resources
- [ ] Create Glue database
- [ ] Create Glue tables for:
  - Group membership
  - User information
  - Dashboard information
  - Usage data

### 6. QuickSight Resources
- [ ] Create QuickSight data source pointing to Athena
- [ ] Create QuickSight datasets
- [ ] Create QuickSight analysis
- [ ] Create QuickSight dashboard
- [ ] Set up appropriate permissions

### 7. CloudWatch Resources
- [ ] Set up CloudWatch Events/EventBridge rules for triggering Lambda functions
- [ ] Configure CloudWatch Logs for Lambda functions

### 8. Documentation
- [ ] Update README.md with comprehensive deployment instructions
- [ ] Document variables and their purposes
- [ ] Create architecture diagram
- [ ] Add usage examples

## Reusability Considerations

1. **Parameterization**:
   - Make all resource names configurable
   - Allow customization of IAM permissions
   - Make QuickSight dashboard elements configurable

2. **Modularity**:
   - Create separate Terraform modules for:
     - IAM resources
     - Lambda functions
     - Athena/Glue resources
     - QuickSight resources

3. **State Management**:
   - Provide instructions for remote state management
   - Consider state locking mechanisms

4. **Versioning**:
   - Set up semantic versioning for the Terraform modules
   - Document compatibility with different Terraform versions

## Next Steps

1. Download and analyze the Lambda function code
2. Create the basic Terraform configuration files
3. Implement IAM roles and policies
4. Implement Lambda functions
5. Implement Athena resources
6. Implement QuickSight resources
7. Test the implementation
8. Document the solution