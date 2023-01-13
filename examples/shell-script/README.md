# Bash Script

This example shows how to execute a bash script with Qovery Lifecycle Job.

## How to use

### Locally

To test locally, you can run the following commands:

```shell
docker build -t shell-script .
```

```shell
docker run \
  -it --entrypoint /bin/sh shell-script \
  -c "run.sh"
```

### Qovery

To use it on Qovery, set up the CMD Arguments to:

For environment start event:
```shell
["create-environment.sh"]
```

For environment stop event:
```shell
["stop-environment.sh"]
```

For environment delete event:
```shell
["delete-environment.sh"]
```
