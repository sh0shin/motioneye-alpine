FROM alpine:edge AS base

# hadolint ignore=DL3018
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
apk update && \
apk upgrade --no-cache --purge --latest --prune && \
apk add --no-cache --purge --latest --upgrade \
curl \
ffmpeg \
logrotate \
motion \
nginx \
openssl \
python3 \
v4l-utils \
&& rm -rf /var/cache/apk/* && find / -depth -regex '^.*\(__pycache__\|\.py[co]\)$' -delete

FROM base AS build

# hadolint ignore=DL3018
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
apk update && \
apk upgrade --no-cache --purge --latest --prune && \
apk add --no-cache --purge --latest --upgrade \
build-base \
curl-dev \
libjpeg-turbo-dev \
python3-dev \
&& rm -rf /var/cache/apk/*

# hadolint ignore=DL3013,SC1091
RUN python3 -m venv --symlinks /motioneye && \
. /motioneye/bin/activate && \
pip install --isolated --no-cache-dir --no-compile --no-input --prefer-binary --upgrade pip setuptools wheel && \
pip install --isolated --no-cache-dir --no-compile --no-input --prefer-binary --upgrade https://github.com/motioneye-project/motioneye/archive/dev.tar.gz && \
pip uninstall --isolated --no-cache-dir --no-input --yes  pip setuptools wheel && \
find / -depth -regex '^.*\(__pycache__\|\.py[co]\)$' -delete && \
find /motioneye -iname '*.so' -exec strip '{}' \;

FROM base AS motioneye

LABEL maintainer="Chris 'sh0shin' Frage <git@sh0shin.org>"

RUN mkdir -p /etc/motioneye /var/lib/motioneye /var/log/motioneye /var/run/motioneye && \
chown -R motion:motion /etc/motioneye /var/lib/motioneye /var/log/motioneye /var/run/motioneye && \
rm /etc/nginx/http.d/default.conf && mkdir -p /var/lib/nginx/ssl

COPY --chown=motion:motion --from=build /motioneye /motioneye
COPY nginx-motioneye.conf /motioneye/nginx-motioneye.conf
COPY nginx-motioneye-ssl.conf /motioneye/nginx-motioneye-ssl.conf

COPY logrotate-nginx /etc/logrotate.d/nginx
#COPY logrotate-motioneye /etc/logrotate.d/motioneye

COPY entrypoint.sh /entrypoint.sh

VOLUME /etc/motioneye
VOLUME /var/lib/motioneye
VOLUME /var/lib/nginx/ssl
VOLUME /var/log/motioneye
VOLUME /var/log/nginx

EXPOSE 8080
EXPOSE 8443
EXPOSE 8765

ENTRYPOINT ["/entrypoint.sh"]
