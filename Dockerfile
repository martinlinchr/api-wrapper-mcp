FROM golang:1.22-alpine AS builder

WORKDIR /app
RUN apk add --no-cache git

# hent din fork (men vi bygger ud fra repoet som ligger i imagen)
COPY . .
RUN go build -o /api_wrapper .

FROM alpine:3.19

WORKDIR /app
COPY --from=builder /api_wrapper /app/api_wrapper
COPY config.yaml /app/config.yaml

ENV API_GATEWAY_TOKEN=changeme
EXPOSE 3000

CMD ["/app/api_wrapper", "/app/config.yaml"]
