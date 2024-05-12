# Use a base image with AWS CLI installed
FROM amazon/aws-cli:2.15.48

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ARG QOVERY_ENVIRONMENT_ID
ARG STACK_NAME_PREFIX="QoveryRDS"

# Set environment variables from arguments
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
ENV QOVERY_ENVIRONMENT_ID=${QOVERY_ENVIRONMENT_ID}
ENV STACK_NAME_PREFIX=${STACK_NAME_PREFIX}

# Work directory for AWS operations
WORKDIR /aws

# Add the CloudFormation template
ADD rds.yml /aws/rds.yml

# Adding entrypoint script
ADD entrypoint.sh /aws/entrypoint.sh
RUN chmod +x /aws/entrypoint.sh

# AWS CloudFormation create or update stack command
ENTRYPOINT [ "/aws/entrypoint.sh" ]
