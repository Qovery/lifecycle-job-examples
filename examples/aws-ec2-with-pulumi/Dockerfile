FROM node:gallium-slim

RUN apt update && apt install curl -y

WORKDIR /app

RUN curl -fsSL https://get.pulumi.com | sh
ENV PATH="/root/.pulumi/bin:${PATH}"

COPY package.json .
COPY package-lock.json .

RUN npm install

COPY . .

ENTRYPOINT [ "/bin/sh" ]
