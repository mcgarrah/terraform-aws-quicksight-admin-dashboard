import json
import boto3
import csv
import os
import datetime
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # Initialize QuickSight client
    quicksight = boto3.client('quicksight')
    s3 = boto3.client('s3')
    
    # Get account ID from Lambda context
    account_id = context.invoked_function_arn.split(":")[4]
    
    # S3 bucket for storing data
    bucket_name = os.environ.get('S3_BUCKET', f'quicksight-admin-console-{account_id}')
    
    # Get list of datasets
    datasets = get_datasets(quicksight, account_id)
    
    # Write data to S3
    write_dataset_data(datasets, bucket_name, s3)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Dataset information processing completed successfully')
    }

def get_datasets(quicksight, account_id):
    datasets = []
    next_token = None
    
    while True:
        if next_token:
            response = quicksight.list_data_sets(
                AwsAccountId=account_id,
                NextToken=next_token
            )
        else:
            response = quicksight.list_data_sets(
                AwsAccountId=account_id
            )
        
        for dataset_summary in response['DataSetSummaries']:
            dataset_id = dataset_summary['DataSetId']
            try:
                dataset_detail = quicksight.describe_data_set(
                    AwsAccountId=account_id,
                    DataSetId=dataset_id
                )
                datasets.append(dataset_detail['DataSet'])
            except Exception as e:
                print(f"Error getting details for dataset {dataset_id}: {str(e)}")
        
        if 'NextToken' in response:
            next_token = response['NextToken']
        else:
            break
    
    return datasets

def write_dataset_data(datasets, bucket_name, s3):
    dataset_data = []
    
    for dataset in datasets:
        dataset_data.append({
            'account_id': dataset.get('Arn', '').split(':')[4],
            'dataset_id': dataset.get('DataSetId', ''),
            'dataset_name': dataset.get('Name', ''),
            'created_time': dataset.get('CreatedTime', '').strftime('%Y-%m-%d %H:%M:%S') if isinstance(dataset.get('CreatedTime'), datetime) else '',
            'last_updated_time': dataset.get('LastUpdatedTime', '').strftime('%Y-%m-%d %H:%M:%S') if isinstance(dataset.get('LastUpdatedTime'), datetime) else '',
            'import_mode': dataset.get('ImportMode', ''),
            'row_level_permission_enabled': str(dataset.get('RowLevelPermissionDataSet', {}).get('Status', 'DISABLED') == 'ENABLED')
        })
    
    csv_data = []
    if dataset_data:
        headers = dataset_data[0].keys()
        csv_data.append(','.join(headers))
        
        for dataset in dataset_data:
            csv_data.append(','.join([str(dataset[h]) for h in headers]))
    
    s3.put_object(
        Bucket=bucket_name,
        Key='dataset_info/dataset_info.csv',
        Body='\n'.join(csv_data)
    )