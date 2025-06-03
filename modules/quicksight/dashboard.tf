variable "dashboard_id" {
  description = "ID for the QuickSight dashboard"
  type        = string
  default     = "quicksight-admin-console"
}

variable "dashboard_name" {
  description = "Name for the QuickSight dashboard"
  type        = string
  default     = "QuickSight Admin Console"
}

# QuickSight Analysis
resource "aws_quicksight_analysis" "admin_console" {
  analysis_id   = "quicksight-admin-console-analysis"
  name          = "QuickSight Admin Console Analysis"
  aws_account_id = var.account_id
  
  # This is a simplified analysis definition
  # In a real implementation, this would be more complex
  source_entity {
    source_template {
      arn = "arn:aws:quicksight:${data.aws_region.current.name}:${var.account_id}:template/default-template"
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.group_membership.arn
        dataset_placeholder = "group_membership"
      }
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.user_info.arn
        dataset_placeholder = "user_info"
      }
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.dashboard_info.arn
        dataset_placeholder = "dashboard_info"
      }
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.dataset_info.arn
        dataset_placeholder = "dataset_info"
      }
    }
  }
  
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
    
    principal = var.admin_arn
  }
}

# QuickSight Dashboard
resource "aws_quicksight_dashboard" "admin_console" {
  dashboard_id   = var.dashboard_id
  name           = var.dashboard_name
  aws_account_id = var.account_id
  
  # This dashboard is based on the analysis
  source_entity {
    source_analysis {
      arn = aws_quicksight_analysis.admin_console.arn
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.group_membership.arn
        dataset_placeholder = "group_membership"
      }
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.user_info.arn
        dataset_placeholder = "user_info"
      }
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.dashboard_info.arn
        dataset_placeholder = "dashboard_info"
      }
      
      data_set_references {
        dataset_arn = aws_quicksight_data_set.dataset_info.arn
        dataset_placeholder = "dataset_info"
      }
    }
  }
  
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
    
    principal = var.admin_arn
  }
}

data "aws_region" "current" {}

output "dashboard_arn" {
  description = "ARN of the QuickSight dashboard"
  value       = aws_quicksight_dashboard.admin_console.arn
}

output "dashboard_url" {
  description = "URL of the QuickSight dashboard"
  value       = "https://${data.aws_region.current.name}.quicksight.aws.amazon.com/sn/dashboards/${aws_quicksight_dashboard.admin_console.dashboard_id}"
}