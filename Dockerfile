FROM debian:11-slim AS builder
FROM gcr.io/distroless/static-debian11:latest
COPY --from=builder /bin/cat /bin/cat
WORKDIR /app
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
