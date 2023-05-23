# Seed your Postgres database with a SQL script

This example shows you how to seed your Postgres database with a SQL script.

## Important

- Our SQL Script downloads from a S3 bucket to avoid storing sensitive data in this repository. This is a good practice to follow.
- You can remove the S3 download part to put a SQL script in this repository. However, it's not recommended to store sensitive data in a public
   repository.

## How to use

1. Fork this repository
2. Create a Lifecycle Job
3. Select your forked repository with the appropriate branch (e.g. `main`)
4. Set the "Root application path" to the example you want to use (e.g. `examples/seed-postgres-database-with-sql-script`)
5. Set the "Dockerfile path" to the Dockerfile in the example you want to use (e.g. `Dockerfile`)
6. Select "Start" event and add the following CMD Arguments: `["seed.sh"]` - which indicates to the Lifecycle Job to run the `seed.sh` script when the Lifecycle Job starts.
7. Create your Lifecycle Job but **do not deploy it yet**.
8. Go to your Lifecycle Job variables and create:
   1. `DATABASE_URL` environment variable alias to provide to `seed.sh` your database connection string where to restore your seed.
   2. `SEED_URL` environment variable alias to provide to `seed.sh` your seed SQL script URL. (can be a public S3 bucket URL or any other URL)
9. Deploy your Lifecycle Job.

Your database is now seeded with your SQL script.
