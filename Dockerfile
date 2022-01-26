FROM golang:1.17 as builder

FROM alpine:3.13
COPY outputs/http-server_linux /http-server

USER nobody
EXPOSE 8080
ENTRYPOINT [ "./http-server" ]
