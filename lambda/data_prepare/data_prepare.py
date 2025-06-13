import json
import boto3
import csv
import os
import logging
from datetime import datetime, timedelta
import time

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Initialize QuickSight client
    quicksight = boto3.client('quicksight')
    s3 = boto3.client('s3')
    
    # Get account ID from Lambda context
    account_id = context.invoked_function_arn.split(":")[4]
    
    # S3 bucket for storing data
    bucket_name = os.environ.get('S3_BUCKET', f'quicksight-admin-console-{account_id}')
    
    # Get list of users
    users = get_users(quicksight, account_id)
    
    # Get list of groups and their members
    groups = get_groups(quicksight, account_id)
    
    # Get list of dashboards
    dashboards = get_dashboards(quicksight, account_id)
    
    # Write data to S3
    write_user_data(users, bucket_name, s3)
    write_group_data(groups, bucket_name, s3)
    write_dashboard_data(dashboards, bucket_name, s3)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Data preparation completed successfully')
    }

def get_users(quicksight, account_id):
    users = []
    next_token = None
    
    while True:
        if next_token:
            response = quicksight.list_users(
                AwsAccountId=account_id,
                Namespace='default',
                NextToken=next_token
            )
        else:
            response = quicksight.list_users(
                AwsAccountId=account_id,
                Namespace='default'
            )
        
        users.extend(response['UserList'])
        
        if 'NextToken' in response:
            next_token = response['NextToken']
        else:
            break
    
    return users

def get_groups(quicksight, account_id):
    groups = []
    next_token = None
    
    while True:
        if next_token:
            response = quicksight.list_groups(
                AwsAccountId=account_id,
                Namespace='default',
                NextToken=next_token
            )
        else:
            response = quicksight.list_groups(
                AwsAccountId=account_id,
                Namespace='default'
            )
        
        for group in response['GroupList']:
            group_name = group['GroupName']
            members = get_group_members(quicksight, account_id, group_name)
            group['Members'] = members
            groups.append(group)
        
        if 'NextToken' in response:
            next_token = response['NextToken']
        else:
            break
    
    return groups

def get_group_members(quicksight, account_id, group_name):
    members = []
    next_token = None
    
    while True:
        if next_token:
            response = quicksight.list_group_memberships(
                AwsAccountId=account_id,
                GroupName=group_name,
                Namespace='default',
                NextToken=next_token
            )
        else:
            response = quicksight.list_group_memberships(
                AwsAccountId=account_id,
                GroupName=group_name,
                Namespace='default'
            )
        
        members.extend(response['GroupMemberList'])
        
        if 'NextToken' in response:
            next_token = response['NextToken']
        else:
            break
    
    return members

def get_dashboards(quicksight, account_id):
    dashboards = []
    next_token = None
    
    while True:
        if next_token:
            response = quicksight.list_dashboards(
                AwsAccountId=account_id,
                NextToken=next_token
            )
        else:
            response = quicksight.list_dashboards(
                AwsAccountId=account_id
            )
        
        for dashboard_summary in response['DashboardSummaryList']:
            dashboard_id = dashboard_summary['DashboardId']
            try:
                dashboard_detail = quicksight.describe_dashboard(
                    AwsAccountId=account_id,
                    DashboardId=dashboard_id
                )
                dashboards.append(dashboard_detail['Dashboard'])
            except Exception as e:
                logger.error(f"Error getting details for dashboard {dashboard_id}: {str(e)}")
                # Implement retry logic for transient errors
                if "ThrottlingException" in str(e) or "RequestTimeout" in str(e):
                    logger.info(f"Retrying dashboard {dashboard_id} after throttling...")
                    time.sleep(1)  # Add backoff delay
                    try:
                        dashboard_detail = quicksight.describe_dashboard(
                            AwsAccountId=account_id,
                            DashboardId=dashboard_id
                        )
                        dashboards.append(dashboard_detail['Dashboard'])
                    except Exception as retry_error:
                        logger.error(f"Retry failed for dashboard {dashboard_id}: {str(retry_error)}")
        
        if 'NextToken' in response:
            next_token = response['NextToken']
        else:
            break
    
    return dashboards

def write_user_data(users, bucket_name, s3):
    user_data = []
    
    for user in users:
        user_data.append({
            'account_id': user.get('Arn', '').split(':')[4],
            'user_name': user.get('UserName', ''),
            'email': user.get('Email', ''),
            'role': user.get('Role', ''),
            'active': user.get('Active', False)
        })
    
    csv_data = []
    if user_data:
        headers = user_data[0].keys()
        csv_data.append(','.join(headers))
        
        for user in user_data:
            csv_data.append(','.join([str(user[h]) for h in headers]))
    
    s3.put_object(
        Bucket=bucket_name,
        Key='user_info/user_info.csv',
        Body='\n'.join(csv_data)
    )

def write_group_data(groups, bucket_name, s3):
    group_data = []
    
    for group in groups:
        account_id = group.get('Arn', '').split(':')[4]
        group_name = group.get('GroupName', '')
        
        for member in group.get('Members', []):
            group_data.append({
                'account_id': account_id,
                'group_name': group_name,
                'user_name': member.get('MemberName', ''),
                'user_role': ''  # Role information might need to be fetched separately
            })
    
    csv_data = []
    if group_data:
        headers = group_data[0].keys()
        csv_data.append(','.join(headers))
        
        for group in group_data:
            csv_data.append(','.join([str(group[h]) for h in headers]))
    
    s3.put_object(
        Bucket=bucket_name,
        Key='group_membership/group_membership.csv',
        Body='\n'.join(csv_data)
    )

def write_dashboard_data(dashboards, bucket_name, s3):
    dashboard_data = []
    
    for dashboard in dashboards:
        dashboard_data.append({
            'account_id': dashboard.get('Arn', '').split(':')[4],
            'dashboard_id': dashboard.get('DashboardId', ''),
            'dashboard_name': dashboard.get('Name', ''),
            'created_time': dashboard.get('CreatedTime', '').strftime('%Y-%m-%d %H:%M:%S') if isinstance(dashboard.get('CreatedTime'), datetime) else '',
            'last_published_time': dashboard.get('LastPublishedTime', '').strftime('%Y-%m-%d %H:%M:%S') if isinstance(dashboard.get('LastPublishedTime'), datetime) else '',
            'last_updated_time': dashboard.get('LastUpdatedTime', '').strftime('%Y-%m-%d %H:%M:%S') if isinstance(dashboard.get('LastUpdatedTime'), datetime) else ''
        })
    
    csv_data = []
    if dashboard_data:
        headers = dashboard_data[0].keys()
        csv_data.append(','.join(headers))
        
        for dashboard in dashboard_data:
            csv_data.append(','.join([str(dashboard[h]) for h in headers]))
    
    s3.put_object(
        Bucket=bucket_name,
        Key='dashboard_info/dashboard_info.csv',
        Body='\n'.join(csv_data)
    )