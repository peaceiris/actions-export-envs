FROM alpine:3.18.0
WORKDIR /app
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
