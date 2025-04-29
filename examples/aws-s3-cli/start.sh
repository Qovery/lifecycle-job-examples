#!/bin/bash

# Script to create an S3 bucket
# Usage: ./start.sh [bucket-name] [region]
# Or set S3_BUCKET_NAME environment variable

# Check if bucket name is provided as argument or environment variable
if [ -z "$1" ] && [ -z "$S3_BUCKET_NAME" ]; then
    echo "Error: Bucket name is required"
    echo "Usage: ./start.sh [bucket-name] [region]"
    echo "Or set S3_BUCKET_NAME environment variable"
    exit 1
fi

# Set the bucket name from argument or environment variable
BUCKET_NAME=${1:-$S3_BUCKET_NAME}

# Set the region (default to us-east-1 if not provided)
REGION=${2:-$AWS_REGION}

# Check if bucket already exists
if aws s3api head-bucket --bucket $BUCKET_NAME 2>/dev/null; then
    echo "Bucket $BUCKET_NAME already exists! Skipping creation."
    exit 0
fi

echo "Creating S3 bucket: $BUCKET_NAME in region: $REGION"
# Create the bucket
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    $(if [ "$REGION" != "us-east-1" ]; then echo "--create-bucket-configuration LocationConstraint=$REGION"; fi)

# Check if the bucket was created successfully
if [ $? -eq 0 ]; then
    echo "Bucket $BUCKET_NAME created successfully!"
    
    # Enable versioning (optional)
    aws s3api put-bucket-versioning \
        --bucket $BUCKET_NAME \
        --versioning-configuration Status=Enabled
    
    echo "Bucket versioning enabled"
else
    echo "Failed to create bucket $BUCKET_NAME"
    exit 1
fi