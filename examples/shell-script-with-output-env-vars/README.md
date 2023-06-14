# Bash Script

This example shows how to execute a bash script and pass environment variables to other services within the same environment with Qovery
[Lifecycle Job](https://hub.qovery.com/docs/using-qovery/configuration/lifecycle-job/#job-output).

## How to use

### Locally

To test locally, you can run the following commands:

```shell
docker build -t shell-script .
```

```shell
docker run shell-script create-environment.sh
```

If you run locally this script it's normal you get an error
`create-environment.sh: 10: cannot create /qovery-output/qovery-output.json: Directory nonexistent` since `/qovery-output/` is a directory
created by Qovery and not locally.

### Qovery

To use it on Qovery, set up the CMD Arguments to:

For environment start event:

```shell
["create-environment.sh"]
```
