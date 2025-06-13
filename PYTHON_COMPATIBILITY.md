# Python 3.12 Compatibility

This document outlines the compatibility considerations for running the QuickSight Admin Dashboard Lambda functions with Python 3.12.

## Compatibility Assessment

The Lambda functions in this project have been reviewed and updated for compatibility with Python 3.12. The following changes were made:

1. Added missing `time` import to `dataset_info.py`
2. Updated the default Lambda runtime to Python 3.12 in `variables.tf`
3. Added validation for the Lambda runtime variable to ensure only supported Python versions are used

## Python 3.12 Features and Benefits

Upgrading to Python 3.12 provides several benefits:

- **Improved Performance**: Python 3.12 includes performance optimizations that can reduce Lambda cold start times and execution duration
- **Enhanced Security**: Latest security patches and improvements
- **Extended AWS Support**: Longer support timeline from AWS for the runtime
- **New Language Features**: Access to the latest Python language features and standard library improvements

## Dependencies

All dependencies used in the Lambda functions are standard libraries that are compatible with Python 3.12:

- `json`: Standard library, fully compatible
- `boto3`: AWS SDK, compatible with Python 3.12
- `csv`: Standard library, fully compatible
- `os`: Standard library, fully compatible
- `logging`: Standard library, fully compatible
- `datetime`: Standard library, fully compatible
- `time`: Standard library, fully compatible

## Testing Recommendations

When deploying with Python 3.12, consider the following testing recommendations:

1. Test the Lambda functions with small datasets first
2. Monitor CloudWatch Logs for any unexpected errors
3. Verify that all QuickSight API calls work as expected
4. Check that CSV formatting and S3 uploads function correctly

## Fallback Options

If you encounter any issues with Python 3.12, you can revert to an earlier Python version by setting the `lambda_runtime` variable:

```hcl
module "quicksight_admin_dashboard" {
  source = "..."
  
  lambda_runtime = "python3.9"  # Fallback to Python 3.9
  
  # Other variables...
}
```

The module supports Python 3.9, 3.10, 3.11, and 3.12 runtimes.