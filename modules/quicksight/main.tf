variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "admin_arn" {
  description = "ARN of the QuickSight admin user"
  type        = string
}

variable "database_name" {
  description = "Name of the Glue database"
  type        = string
}

variable "group_membership_table" {
  description = "Name of the group membership table"
  type        = string
}

variable "user_info_table" {
  description = "Name of the user info table"
  type        = string
}

variable "dashboard_info_table" {
  description = "Name of the dashboard info table"
  type        = string
}

variable "dataset_info_table" {
  description = "Name of the dataset info table"
  type        = string
}

# QuickSight Data Source
resource "aws_quicksight_data_source" "athena" {
  name           = "athena-admin-console"
  data_source_id = "athena-admin-console"
  aws_account_id = var.account_id
  
  type = "ATHENA"
  
  parameters {
    athena {
      work_group = "primary"
    }
  }
  
  ssl_properties {
    disable_ssl = false
  }
  
  permissions {
    actions = [
      "quicksight:UpdateDataSourcePermissions",
      "quicksight:DescribeDataSource",
      "quicksight:DescribeDataSourcePermissions",
      "quicksight:PassDataSource",
      "quicksight:UpdateDataSource",
      "quicksight:DeleteDataSource"
    ]
    
    principal = var.admin_arn
  }
}

# QuickSight Dataset for Group Membership
resource "aws_quicksight_data_set" "group_membership" {
  name           = "group-membership"
  data_set_id    = "group-membership"
  aws_account_id = var.account_id
  
  import_mode = "DIRECT_QUERY"
  
  physical_table_map {
    physical_table_map_id = "group-membership-table"
    relational_table {
      data_source_arn = aws_quicksight_data_source.athena.arn
      schema          = var.database_name
      name            = var.group_membership_table
    }
  }
  
  permissions {
    actions = [
      "quicksight:UpdateDataSetPermissions",
      "quicksight:DescribeDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:PassDataSet",
      "quicksight:DescribeIngestion",
      "quicksight:ListIngestions",
      "quicksight:UpdateDataSet",
      "quicksight:DeleteDataSet",
      "quicksight:CreateIngestion",
      "quicksight:CancelIngestion"
    ]
    
    principal = var.admin_arn
  }
}

# QuickSight Dataset for User Info
resource "aws_quicksight_data_set" "user_info" {
  name           = "user-info"
  data_set_id    = "user-info"
  aws_account_id = var.account_id
  
  import_mode = "DIRECT_QUERY"
  
  physical_table_map {
    physical_table_map_id = "user-info-table"
    relational_table {
      data_source_arn = aws_quicksight_data_source.athena.arn
      schema          = var.database_name
      name            = var.user_info_table
    }
  }
  
  permissions {
    actions = [
      "quicksight:UpdateDataSetPermissions",
      "quicksight:DescribeDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:PassDataSet",
      "quicksight:DescribeIngestion",
      "quicksight:ListIngestions",
      "quicksight:UpdateDataSet",
      "quicksight:DeleteDataSet",
      "quicksight:CreateIngestion",
      "quicksight:CancelIngestion"
    ]
    
    principal = var.admin_arn
  }
}

# QuickSight Dataset for Dashboard Info
resource "aws_quicksight_data_set" "dashboard_info" {
  name           = "dashboard-info"
  data_set_id    = "dashboard-info"
  aws_account_id = var.account_id
  
  import_mode = "DIRECT_QUERY"
  
  physical_table_map {
    physical_table_map_id = "dashboard-info-table"
    relational_table {
      data_source_arn = aws_quicksight_data_source.athena.arn
      schema          = var.database_name
      name            = var.dashboard_info_table
    }
  }
  
  permissions {
    actions = [
      "quicksight:UpdateDataSetPermissions",
      "quicksight:DescribeDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:PassDataSet",
      "quicksight:DescribeIngestion",
      "quicksight:ListIngestions",
      "quicksight:UpdateDataSet",
      "quicksight:DeleteDataSet",
      "quicksight:CreateIngestion",
      "quicksight:CancelIngestion"
    ]
    
    principal = var.admin_arn
  }
}

# QuickSight Dataset for Dataset Info
resource "aws_quicksight_data_set" "dataset_info" {
  name           = "dataset-info"
  data_set_id    = "dataset-info"
  aws_account_id = var.account_id
  
  import_mode = "DIRECT_QUERY"
  
  physical_table_map {
    physical_table_map_id = "dataset-info-table"
    relational_table {
      data_source_arn = aws_quicksight_data_source.athena.arn
      schema          = var.database_name
      name            = var.dataset_info_table
    }
  }
  
  permissions {
    actions = [
      "quicksight:UpdateDataSetPermissions",
      "quicksight:DescribeDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:PassDataSet",
      "quicksight:DescribeIngestion",
      "quicksight:ListIngestions",
      "quicksight:UpdateDataSet",
      "quicksight:DeleteDataSet",
      "quicksight:CreateIngestion",
      "quicksight:CancelIngestion"
    ]
    
    principal = var.admin_arn
  }
}

output "data_source_arn" {
  description = "ARN of the QuickSight data source"
  value       = aws_quicksight_data_source.athena.arn
}

output "group_membership_dataset_arn" {
  description = "ARN of the group membership dataset"
  value       = aws_quicksight_data_set.group_membership.arn
}

output "user_info_dataset_arn" {
  description = "ARN of the user info dataset"
  value       = aws_quicksight_data_set.user_info.arn
}

output "dashboard_info_dataset_arn" {
  description = "ARN of the dashboard info dataset"
  value       = aws_quicksight_data_set.dashboard_info.arn
}

output "dataset_info_dataset_arn" {
  description = "ARN of the dataset info dataset"
  value       = aws_quicksight_data_set.dataset_info.arn
}