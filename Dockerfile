FROM alpine:3.21.3
WORKDIR /app
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
