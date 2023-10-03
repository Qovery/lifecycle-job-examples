FROM debian:12

ARG HELM_VERSION=3.13.0

RUN apt-get update && apt-get -y install curl unzip git && apt-get clean

# AWS CLI
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-$(dpkg --print-architecture | sed 's/amd64/x86_64/' | sed 's/arm64/aarch64/').zip -o awscliv2.zip && unzip awscliv2.zip && rm awscliv2.zip && ./aws/install

# Helm
RUN export PLATFORM_NAME="linux-$(dpkg --print-architecture)" ; curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-${PLATFORM_NAME}.tar.gz -o helm.tgz && tar -xzf helm.tgz ${PLATFORM_NAME}/helm && mv ${PLATFORM_NAME}/helm /usr/bin && chmod 755 /usr/bin/helm && rm -Rf helm.tgz ${PLATFORM_NAME}

# Helm diff
RUN helm plugin install https://github.com/databus23/helm-diff

ADD run.sh /

ENTRYPOINT ["/run.sh"]
