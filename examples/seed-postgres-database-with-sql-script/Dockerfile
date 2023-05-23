FROM debian:11-slim

RUN apt update && apt install postgresql-client curl -y

WORKDIR /app

COPY seed.sh .

RUN chmod +x seed.sh

ENTRYPOINT [ "/bin/sh" ]

