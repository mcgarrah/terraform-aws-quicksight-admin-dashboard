variable "database_name" {
  description = "Name of the Glue database"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for data storage"
  type        = string
}

variable "cloudtrail_location" {
  description = "Location of CloudTrail logs in S3"
  type        = string
}

# Glue Database
resource "aws_glue_catalog_database" "this" {
  name = var.database_name
}

# Group Membership Table
resource "aws_glue_catalog_table" "group_membership" {
  name          = "group_membership"
  database_name = aws_glue_catalog_database.this.name
  
  table_type = "EXTERNAL_TABLE"
  
  parameters = {
    "has_encrypted_data" = "false"
    "classification"     = "csv"
    "areColumnsQuoted"   = "false"
    "typeOfData"         = "file"
    "columnsOrdered"     = "true"
    "delimiter"          = ","
  }
  
  storage_descriptor {
    location      = "s3://${var.s3_bucket}/group_membership/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      
      parameters = {
        "field.delim" = ","
      }
    }
    
    columns {
      name = "account_id"
      type = "string"
    }
    
    columns {
      name = "group_name"
      type = "string"
    }
    
    columns {
      name = "user_name"
      type = "string"
    }
    
    columns {
      name = "user_role"
      type = "string"
    }
  }
}

# User Information Table
resource "aws_glue_catalog_table" "user_info" {
  name          = "user_info"
  database_name = aws_glue_catalog_database.this.name
  
  table_type = "EXTERNAL_TABLE"
  
  parameters = {
    "has_encrypted_data" = "false"
    "classification"     = "csv"
    "areColumnsQuoted"   = "false"
    "typeOfData"         = "file"
    "columnsOrdered"     = "true"
    "delimiter"          = ","
  }
  
  storage_descriptor {
    location      = "s3://${var.s3_bucket}/user_info/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      
      parameters = {
        "field.delim" = ","
      }
    }
    
    columns {
      name = "account_id"
      type = "string"
    }
    
    columns {
      name = "user_name"
      type = "string"
    }
    
    columns {
      name = "email"
      type = "string"
    }
    
    columns {
      name = "role"
      type = "string"
    }
    
    columns {
      name = "active"
      type = "boolean"
    }
  }
}

# Dashboard Information Table
resource "aws_glue_catalog_table" "dashboard_info" {
  name          = "dashboard_info"
  database_name = aws_glue_catalog_database.this.name
  
  table_type = "EXTERNAL_TABLE"
  
  parameters = {
    "has_encrypted_data" = "false"
    "classification"     = "csv"
    "areColumnsQuoted"   = "false"
    "typeOfData"         = "file"
    "columnsOrdered"     = "true"
    "delimiter"          = ","
  }
  
  storage_descriptor {
    location      = "s3://${var.s3_bucket}/dashboard_info/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      
      parameters = {
        "field.delim" = ","
      }
    }
    
    columns {
      name = "account_id"
      type = "string"
    }
    
    columns {
      name = "dashboard_id"
      type = "string"
    }
    
    columns {
      name = "dashboard_name"
      type = "string"
    }
    
    columns {
      name = "created_time"
      type = "timestamp"
    }
    
    columns {
      name = "last_published_time"
      type = "timestamp"
    }
    
    columns {
      name = "last_updated_time"
      type = "timestamp"
    }
  }
}

# Dataset Information Table
resource "aws_glue_catalog_table" "dataset_info" {
  name          = "dataset_info"
  database_name = aws_glue_catalog_database.this.name
  
  table_type = "EXTERNAL_TABLE"
  
  parameters = {
    "has_encrypted_data" = "false"
    "classification"     = "csv"
    "areColumnsQuoted"   = "false"
    "typeOfData"         = "file"
    "columnsOrdered"     = "true"
    "delimiter"          = ","
  }
  
  storage_descriptor {
    location      = "s3://${var.s3_bucket}/dataset_info/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      
      parameters = {
        "field.delim" = ","
      }
    }
    
    columns {
      name = "account_id"
      type = "string"
    }
    
    columns {
      name = "dataset_id"
      type = "string"
    }
    
    columns {
      name = "dataset_name"
      type = "string"
    }
    
    columns {
      name = "created_time"
      type = "timestamp"
    }
    
    columns {
      name = "last_updated_time"
      type = "timestamp"
    }
    
    columns {
      name = "import_mode"
      type = "string"
    }
    
    columns {
      name = "row_level_permission_enabled"
      type = "boolean"
    }
  }
}

output "database_name" {
  description = "Name of the Glue database"
  value       = aws_glue_catalog_database.this.name
}

output "group_membership_table" {
  description = "Name of the group membership table"
  value       = aws_glue_catalog_table.group_membership.name
}

output "user_info_table" {
  description = "Name of the user info table"
  value       = aws_glue_catalog_table.user_info.name
}

output "dashboard_info_table" {
  description = "Name of the dashboard info table"
  value       = aws_glue_catalog_table.dashboard_info.name
}

output "dataset_info_table" {
  description = "Name of the dataset info table"
  value       = aws_glue_catalog_table.dataset_info.name
}