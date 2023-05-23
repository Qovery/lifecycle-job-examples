#!/bin/env bash

# Define required environment variables
REQUIRED_VARS=("AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY" "AWS_DEFAULT_REGION" "AWS_BUCKET_NAME" "AWS_CLOUDFRONT_DISTRIBUTION_ID")

# Loop over required environment variables and check if they are set
for VAR_NAME in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!VAR_NAME}" ]]; then
    echo "The $VAR_NAME environment variable is not set."
    exit 1
  fi
done

# Upload to S3
aws s3 sync ./out s3://$AWS_BUCKET_NAME

# Invalidate CloudFront cache
INVALIDATION_ID=$(aws cloudfront create-invalidation --distribution-id $AWS_CLOUDFRONT_DISTRIBUTION_ID --paths "/*" --query 'Invalidation.Id' --output text)

# Wait for the invalidation to complete
aws cloudfront wait invalidation-completed --distribution-id $AWS_CLOUDFRONT_DISTRIBUTION_ID --id $INVALIDATION_ID
