FROM alpine:latest

RUN apk add --no-cache wget unzip ca-certificates bash

RUN wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip v2ray-linux-64.zip -d /usr/bin/ && \
    chmod +x /usr/bin/v2ray && \
    rm v2ray-linux-64.zip

RUN mkdir -p /etc/v2ray
COPY config.json /etc/v2ray/config.json

EXPOSE 8080

CMD ["/usr/bin/v2ray", "run", "-c", "/etc/v2ray/config.json"]

