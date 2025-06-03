# Athena resources for QuickSight Admin Dashboard

# Group Membership Table
resource "aws_glue_catalog_table" "group_membership" {
  name          = "group_membership"
  database_name = aws_glue_catalog_database.admin_console.name
  
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
    location      = "s3://${aws_s3_bucket.data_storage.bucket}/group_membership/"
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
  database_name = aws_glue_catalog_database.admin_console.name
  
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
    location      = "s3://${aws_s3_bucket.data_storage.bucket}/user_info/"
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
  database_name = aws_glue_catalog_database.admin_console.name
  
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
    location      = "s3://${aws_s3_bucket.data_storage.bucket}/dashboard_info/"
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

# CloudTrail Usage Data Table
resource "aws_glue_catalog_table" "cloudtrail_logs" {
  name          = "cloudtrail_logs"
  database_name = aws_glue_catalog_database.admin_console.name
  
  table_type = "EXTERNAL_TABLE"
  
  parameters = {
    "has_encrypted_data" = "false"
    "classification"     = "json"
    "typeOfData"         = "file"
  }
  
  storage_descriptor {
    location      = "s3://${var.cloudtrail_location}"
    input_format  = "com.amazon.emr.cloudtrail.CloudTrailInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info {
      name                  = "cloudtrail-serde"
      serialization_library = "com.amazon.emr.hive.serde.CloudTrailSerde"
    }
    
    # CloudTrail table columns would be defined here
    # This is a simplified version and would need to be expanded
    columns {
      name = "eventversion"
      type = "string"
    }
    
    columns {
      name = "useridentity"
      type = "struct<type:string,principalid:string,arn:string,accountid:string,invokedby:string,accesskeyid:string,username:string,sessioncontext:struct<attributes:struct<mfaauthenticated:string,creationdate:string>,sessionissuer:struct<type:string,principalid:string,arn:string,accountid:string,username:string>>>"
    }
    
    columns {
      name = "eventtime"
      type = "string"
    }
    
    columns {
      name = "eventsource"
      type = "string"
    }
    
    columns {
      name = "eventname"
      type = "string"
    }
    
    columns {
      name = "awsregion"
      type = "string"
    }
    
    columns {
      name = "sourceipaddress"
      type = "string"
    }
    
    columns {
      name = "useragent"
      type = "string"
    }
    
    columns {
      name = "requestparameters"
      type = "string"
    }
    
    columns {
      name = "responseelements"
      type = "string"
    }
    
    columns {
      name = "requestid"
      type = "string"
    }
    
    columns {
      name = "eventid"
      type = "string"
    }
    
    columns {
      name = "resources"
      type = "array<struct<arn:string,accountid:string,type:string>>"
    }
    
    columns {
      name = "eventtype"
      type = "string"
    }
    
    columns {
      name = "apiversion"
      type = "string"
    }
    
    columns {
      name = "readonly"
      type = "string"
    }
    
    columns {
      name = "recipientaccountid"
      type = "string"
    }
    
    columns {
      name = "serviceeventdetails"
      type = "string"
    }
    
    columns {
      name = "sharedeventid"
      type = "string"
    }
    
    columns {
      name = "vpcendpointid"
      type = "string"
    }
  }
}