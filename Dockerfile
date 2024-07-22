FROM alpine:3.20.2
WORKDIR /app
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
