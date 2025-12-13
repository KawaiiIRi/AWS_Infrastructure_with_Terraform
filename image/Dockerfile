# image/Dockerfile\
# 試験用としてGoをベースイメージに使用する。
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o app

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/app .
# ポートやエントリポイントはアプリに合わせて変更
EXPOSE 8080
CMD ["./app"]
