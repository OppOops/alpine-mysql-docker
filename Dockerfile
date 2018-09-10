FROM alpine:latest
WORKDIR /app
COPY ./deploy /app/deploy
RUN apk add --no-cache mysql mysql-client
ENTRYPOINT ["/app/deploy/mysql_init.sh"]
