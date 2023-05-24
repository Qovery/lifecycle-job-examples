#!/bin/env bash

# set -e at the beginning of the script to cause the shell to exit if any command exits with a non-zero status.
set -e

# set -u to treat unset variables as an error and immediately exit.
# This would reduce the need for manual checks for the presence of environment variables.
set -u

# set -o pipefail to cause the script to fail if any of the commands piped together fail.
set -o pipefail

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

# Download the SQL dump
curl "${SEED_URL}" -o seed.sql

# Check if seed.sql exists in the current directory
if [[ ! -f "seed.sql" ]]; then
  echo "The seed.sql file could not be found in the current directory."
  exit 1
fi

echo "Database seeding started."

# Seed the database
if [[ "${RESTORE_METHOD}" == "pg_restore" ]]; then
  pg_restore -d "$DATABASE_URL" seed.sql
elif [[ "${RESTORE_METHOD}" == "psql" ]]; then
  psql "$DATABASE_URL" < seed.sql
else
  echo "Invalid restore method. Please set the RESTORE_METHOD environment variable to either 'pg_restore' or 'psql'."
  exit 1
fi

echo "Database seeding completed successfully."
