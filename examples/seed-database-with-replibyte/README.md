# Seed your database with Replibyte

Please refer to the [Replibyte documentation](https://www.replibyte.com) to fit this guide to your need.

> [Replibyte](https://github.com/Qovery/replibyte) is an open-source tool to seed your database with production data while keeping sensitive data safe.

## Prerequisites

I assume you have already created a database dump with Replibyte and you are ready to use `replibyte restore` command. If it's not the case,
please refer to how to [create a dump](https://www.replibyte.com/docs/guides/create-a-dump).

**Note** ✨: you can use the [Qovery Cronjob](https://hub.qovery.com/docs/using-qovery/configuration/cronjob/) to regularly create a dump of
your database.

## How to use

*Before moving forward, modify `replibyte.yaml` with your configuration. In my example, I use a [local dump](datastore) instead of a dump on
a S3 bucket, which is just for the demo purpose*

1. Fork this repository
2. Modify the `replitye.yaml` to reflect your database configuration.
3. Create a Lifecycle Job
4. Select your forked repository with the appropriate branch (e.g. `main`)
5. Set the "Root application path" to the example you want to use (e.g. `examples/seed-a-database-with-replibyte`)
6. Set the "Dockerfile path" to the Dockerfile in the example you want to use (e.g. `Dockerfile`)
7. Select "Start" event and add the following CMD Arguments: `["-c","replibyte -c replibyte.yaml dump restore remote -v latest"]` - which
   indicates that you want to restore the latest dump. Please refer to
   the [Replibyte documentation](https://www.replibyte.com/docs/guides/restore-a-dump) for more information.
8. Create your Lifecycle Job but **do not deploy it yet**.
9. Go to your Lifecycle Job variables and create a `DATABASE_URL` environment variable alias to provide to replibyte your database
   connection string where to restore your seed.
10. Deploy your Lifecycle Job.

Your database is now seeded with your production-like data.
