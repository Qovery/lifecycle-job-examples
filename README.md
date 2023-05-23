# Lifecycle Job Examples

This repository contains ready to use Qovery Lifecycle Jobs examples

## How to use

1. Fork this project
2. [Create a new Lifecycle Job](https://hub.qovery.com/docs/using-qovery/configuration/lifecycle-job/)
3. Select your forked repository with the appropriate branch (e.g. `main`)
4. Set the "Root application path" to the example you want to use (e.g. `examples/seed-a-database-with-replibyte`)
5. Set the "Dockerfile path" to the Dockerfile in the example you want to use (e.g. `Dockerfile`)

> Are you looking for a complete Lifecycle Job guide?
> Check [this one](https://hub.qovery.com/guides/tutorial/how-to-use-lifecycle-job-to-deploy-any-kind-of-resources/)

## Documentation

- [The Lifecycle Job documentation](https://hub.qovery.com/docs/using-qovery/configuration/lifecycle-job/).

## Examples

Here is a list of all the examples

| Description                                                            | Folder                                                              |
|------------------------------------------------------------------------|---------------------------------------------------------------------|
| Seed a Postgres database with a SQL script                             | [here](/examples/seed-postgres-database-with-sql-script)            |
| Seed a database with [Replibyte](https://github.com/Qovery/Replibyte)  | [here](/examples/seed-database-with-replibyte)                      |
| Call HTTP endpoint when an Environment is created                      | [here](/examples/call-http-endpoint-when-an-environment-is-created) |
| Create and Destroy an AWS RDS instance with Terraform                  | [here](/examples/aws-rds-with-terraform)                            |
| Create and Destroy an AWS Lambda with Serverless                       | [here](/examples/aws-lambda-with-serverless)                        |
| Create and Destroy an AWS EC2 instance with Pulumi                     | [here](/examples/aws-ec2-with-pulumi)                               |
| Execute a Helm chart                                                   | [here](/examples/helm)                                              |
| Execute a shell script                                                 | [here](/examples/shell-script)                                      |
| Build static frontend app (NextJS) and upload assets on AWS Cloudfront | [here](/examples/deploy-nextjs-app-on-cloudfront)                   |
| Create and Destroy a MongoDB Atlas instance with Terraform             | WIP                                                                 |

## How to contribute

* Do you need any help? Open an issue.
* Do you want to share a template? Open a Pull Request.

## Contact

Feel free to contact us via [our public forum](https://discuss.qovery.com)
