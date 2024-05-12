# AWS RDS with CloudFormation

## Start command

```shell
["aws cloudformation deploy --template-file rds.yml --stack-name $STACK_NAME --parameter-overrides QoveryEnvironmentId=$QOVERY_ENVIRONMENT_ID --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM && aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs' --output json > /qovery-output/qovery-output.json"]
```

## Delete command

```shell
["aws cloudformation delete-stack --stack-name $STACK_NAME"]
```
