# AWS S3 CLI Example with Qovery Lifecycle Job

This example demonstrates how to use AWS S3 CLI commands within a Qovery Lifecycle Job.

## Overview

This project shows how to:

- Set up a Lifecycle Job in Qovery
- Use AWS S3 CLI to interact with S3 buckets
- Execute S3 operations as automated tasks (create and delete buckets)

## Configuration

1. Configure your Qovery Lifecycle Job with:
   - **Start script**: `/app/scripts/start.sh`
   - **Stop script**: `/app/scripts/stop.sh`
2. Set up AWS credentials as environment variables and S3 bucket names in the Qovery environment:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_DEFAULT_REGION`
   - `S3_BUCKET_NAME`

## Usage

The Lifecycle Job will execute the specified AWS S3 CLI commands based on your configuration.

When you start it, you should see output similar to:

```bash
Creating S3 bucket: test-bucket in region: us-east-2
{
    "Location": "http://test-bucket.s3.amazonaws.com/"
}
Bucket test-bucket created successfully!
Bucket versioning enabled
```

Check the Qovery documentation for more details on setting up and managing Lifecycle Jobs.

## Resources

- [Qovery Documentation](https://hub.qovery.com/docs/using-qovery/configuration/lifecycle-job/)
- [AWS S3 CLI Documentation](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/index.html)
