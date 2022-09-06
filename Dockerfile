FROM node:lts-alpine
ADD ui /app
ADD modules/speedtest/speedtest_worker.js /app/public/speedtest_worker.js
WORKDIR /app
RUN npm i && \
    npm run build

FROM alpine:3.16
LABEL maintainer="shaggygb <noreply@southerncrossdata.com>"

RUN apk add --no-cache php81 php81-pecl-maxminddb php81-ctype php81-pecl-swoole nginx xz \
    iperf iperf3 \
    mtr \
    traceroute \
    iputils

ADD backend/app /app
COPY --from=0 /app/dist /app/webspaces

CMD php81 /app/app.php
