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
- [x] Set up provider configuration
- [x] Create variables.tf for configurable parameters
- [x] Create outputs.tf for important resource outputs

### 2. IAM Resources
- [x] Create IAM role for Lambda functions with appropriate permissions
- [ ] Create service-linked roles if needed

### 3. Lambda Functions
- [x] Extract and analyze Lambda function code from the CloudFormation templates
- [x] Create Lambda function resources in Terraform
- [x] Set up Lambda environment variables
- [x] Configure Lambda triggers and permissions

### 4. S3 Buckets
- [x] Create S3 bucket for storing Lambda code
- [x] Create S3 bucket for CloudTrail logs (if needed)
- [ ] Set up appropriate bucket policies

### 5. Athena Resources
- [x] Create Glue database
- [x] Create Glue tables for:
  - Group membership
  - User information
  - Dashboard information
  - Dataset information

### 6. QuickSight Resources
- [x] Create QuickSight data source pointing to Athena
- [x] Create QuickSight datasets
- [ ] Create QuickSight analysis
- [ ] Create QuickSight dashboard
- [x] Set up appropriate permissions

### 7. CloudWatch Resources
- [x] Set up CloudWatch Events/EventBridge rules for triggering Lambda functions
- [x] Configure CloudWatch Logs for Lambda functions

### 8. Documentation
- [x] Update README.md with comprehensive deployment instructions
- [x] Document variables and their purposes
- [x] Create architecture diagram
- [ ] Add usage examples

## Reusability Considerations

1. **Parameterization**:
   - [x] Make all resource names configurable
   - [x] Allow customization of IAM permissions
   - [ ] Make QuickSight dashboard elements configurable

2. **Modularity**:
   - [x] Create separate Terraform modules for:
     - [x] Lambda functions
     - [x] Athena/Glue resources
     - [x] QuickSight resources
     - [ ] IAM resources (currently in main.tf)

3. **State Management**:
   - [ ] Provide instructions for remote state management
   - [ ] Consider state locking mechanisms

4. **Versioning**:
   - [ ] Set up semantic versioning for the Terraform modules
   - [x] Document compatibility with different Terraform versions

## Remaining Tasks

1. **QuickSight Analysis and Dashboard**:
   - Create QuickSight analysis resource in Terraform
   - Create QuickSight dashboard resource in Terraform
   - Define dashboard visualizations and layout

2. **Security Enhancements**:
   - Add S3 bucket policies for data protection
   - Refine IAM permissions to follow least privilege principle
   - Create a dedicated IAM module

3. **State Management**:
   - Add instructions for remote state management (S3 + DynamoDB)
   - Document state locking approach

4. **Documentation**:
   - Add detailed usage examples
   - Create deployment guide with step-by-step instructions
   - Document troubleshooting steps

5. **Testing**:
   - Test deployment in multiple AWS accounts
   - Validate data collection and dashboard functionality
   - Create test cases for different QuickSight configurations

## Next Steps

1. Implement QuickSight analysis and dashboard resources
2. Enhance security with bucket policies and refined IAM permissions
3. Add remote state management instructions
4. Complete documentation with usage examples
5. Test the implementation in different environments