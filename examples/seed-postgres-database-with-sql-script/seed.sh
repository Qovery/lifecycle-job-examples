#!/bin/env bash

# Check if DATABASE_URL is set
if [[ -z "${DATABASE_URL}" ]]; then
  echo "The DATABASE_URL environment variable is not set."
  exit 1
fi

# Check if psql is installed
if ! command -v psql &> /dev/null; then
  echo "psql could not be found. Please install it and try again."
  exit 1
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "curl could not be found. Please install it and try again."
  exit 1
fi

# Define the URL of the SQL dump on the S3 bucket
# SEED_URL="http://your-bucket.s3.amazonaws.com/seed.sql"

# Check if DATABASE_URL is set
if [[ -z "${SEED_URL}" ]]; then
  echo "The SEED_URL environment variable is not set."
  exit 1
fi

# Download the SQL dump
curl "${SEED_URL}" -o seed.sql

if [[ $? -ne 0 ]]; then
  echo "An error occurred while downloading the SQL dump."
  exit 1
fi

# Check if seed.sql exists in the current directory
if [[ ! -f "seed.sql" ]]; then
  echo "The seed.sql file could not be found in the current directory."
  exit 1
fi

echo "Database seeding started."

# Seed the database
pg_restore -d "$DATABASE_URL" seed.sql

if [[ $? -eq 0 ]]; then
  echo "Database seeding completed successfully."
else
  echo "An error occurred while seeding the database."
  exit 1
fi
