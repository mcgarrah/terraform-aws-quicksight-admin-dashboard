# QuickSight resources for Admin Dashboard

# QuickSight Data Source
resource "aws_quicksight_data_source" "athena_admin_console" {
  name          = "athena-admin-console"
  data_source_id = "athena-admin-console"
  aws_account_id = data.aws_caller_identity.current.account_id
  
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
    
    principal = var.quicksight_admin_arn
  }
}

# Note: The following resources would be created but are commented out as they require
# more detailed configuration based on the actual QuickSight datasets, analyses, and dashboards

# QuickSight Dataset for Group Membership
/*
resource "aws_quicksight_data_set" "group_membership" {
  name          = "group-membership"
  data_set_id   = "group-membership"
  aws_account_id = data.aws_caller_identity.current.account_id
  
  import_mode = "DIRECT_QUERY"
  
  physical_table_map {
    physical_table_map_id = "group-membership-table"
    relational_table {
      data_source_arn = aws_quicksight_data_source.athena_admin_console.arn
      schema          = aws_glue_catalog_database.admin_console.name
      name            = aws_glue_catalog_table.group_membership.name
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
    
    principal = var.quicksight_admin_arn
  }
}
*/

# Additional QuickSight datasets would be defined here

# QuickSight Analysis
/*
resource "aws_quicksight_analysis" "admin_console" {
  name          = "QuickSight-Admin-Console"
  analysis_id   = "quicksight-admin-console"
  aws_account_id = data.aws_caller_identity.current.account_id
  
  # Analysis definition would be specified here
  # This requires a complex JSON structure that defines the analysis
  
  permissions {
    actions = [
      "quicksight:RestoreAnalysis",
      "quicksight:UpdateAnalysisPermissions",
      "quicksight:DeleteAnalysis",
      "quicksight:QueryAnalysis",
      "quicksight:DescribeAnalysisPermissions",
      "quicksight:DescribeAnalysis",
      "quicksight:UpdateAnalysis"
    ]
    
    principal = var.quicksight_admin_arn
  }
}
*/

# QuickSight Dashboard
/*
resource "aws_quicksight_dashboard" "admin_console" {
  name           = "QuickSight-Admin-Console"
  dashboard_id   = "quicksight-admin-console"
  aws_account_id = data.aws_caller_identity.current.account_id
  
  # Dashboard definition would be specified here
  # This requires a complex JSON structure that defines the dashboard
  
  permissions {
    actions = [
      "quicksight:DescribeDashboard",
      "quicksight:ListDashboardVersions",
      "quicksight:UpdateDashboardPermissions",
      "quicksight:QueryDashboard",
      "quicksight:UpdateDashboard",
      "quicksight:DeleteDashboard",
      "quicksight:DescribeDashboardPermissions",
      "quicksight:UpdateDashboardPublishedVersion"
    ]
    
    principal = var.quicksight_admin_arn
  }
}
*/