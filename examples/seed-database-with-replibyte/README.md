# Seed your database with Replibyte

Please refer to the [Replibyte documentation](https://www.replibyte.com) to fit this guide to your need.

> [Replibyte](https://github.com/Qovery/replibyte) is an open-source tool to seed your database with production data while keeping sensitive data safe. 

## Prerequisites

I assume you have already created a database dump with Replibyte and you are ready to use `replibyte restore` command. If it's not the case, please refer to how to [create a dump](https://www.replibyte.com/docs/guides/create-a-dump).

**Note** ✨: you can use the [Qovery Cronjob](https://hub.qovery.com/docs/using-qovery/configuration/cronjob/) to regularly create a dump of your database.

## How to use

*Before moving forward, modify `replibyte.yaml` with your configuration. In my example, I use a [local dump](datastore) instead of a dump on a S3 bucket, which is just for the demo purpose*

