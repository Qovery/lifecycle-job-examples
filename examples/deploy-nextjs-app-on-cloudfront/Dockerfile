# ---- Base Node ----
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run build

# ---- AWS CLI ----
FROM amazon/aws-cli:2.11.21 AS awscli

# ---- Final ----
FROM debian:buster-slim AS release
WORKDIR /app
COPY --from=build /app/out ./
COPY --from=awscli /usr/local/aws-cli/v2/current/dist/aws /usr/local/bin
COPY upload.sh .
RUN chmod +x upload.sh

ENTRYPOINT [ "/bin/sh" ]
