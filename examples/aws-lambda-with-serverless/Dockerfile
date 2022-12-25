FROM node:gallium-slim

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

WORKDIR /app

RUN npm install -g serverless

COPY . .

RUN serverless plugin install -n serverless-manifest-plugin

ENTRYPOINT [ "entrypoint.sh" ]
