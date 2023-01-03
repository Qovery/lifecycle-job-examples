FROM debian:11

ARG HELM_VERSION=3.10.3

RUN apt-get update && apt-get -y install curl unzip git && apt-get clean

# AWS CLI
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && unzip awscliv2.zip && rm awscliv2.zip && ./aws/install

# Helm
RUN curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tgz && tar -xzf helm.tgz linux-amd64/helm && mv linux-amd64/helm /usr/bin && chmod 755 /usr/bin/helm && rm -Rf helm.tgz linux-amd64

# Helm diff
RUN helm plugin install https://github.com/databus23/helm-diff

ADD run.sh /

ENTRYPOINT ["/run.sh"]
