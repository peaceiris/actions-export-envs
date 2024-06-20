FROM alpine:3.20.1
WORKDIR /app
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
