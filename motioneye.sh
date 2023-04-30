#!/usr/bin/env bash
# vim: set ft=sh syn=bash :
# shellcheck shell=bash

set -eu -o pipefail

MOTIONEYE_NAME="motioneye"
MOTIONEYE_RESTART="always"
MOTIONEYE_PORTS=(
  --publish 8765:8765
  --publish 8080:8080
)

MOTIONEYE_IMAGE="sh0shin/motioneye-alpine"
MOTIONEYE_TAG="devel"

MOTIONEYE_DATA="/data/motioneye"

[ -d "${MOTIONEYE_DATA}/video" ] && mv "${MOTIONEYE_DATA}/video" "${MOTIONEYE_DATA}/media"

[ ! -d "${MOTIONEYE_DATA}/config" ] && mkdir -p "${MOTIONEYE_DATA}/config"
[ ! -d "${MOTIONEYE_DATA}/log" ] && mkdir -p "${MOTIONEYE_DATA}/log"
[ ! -d "${MOTIONEYE_DATA}/media" ] && mkdir -p "${MOTIONEYE_DATA}/media"
[ ! -d "${MOTIONEYE_DATA}/nginx/log" ] && mkdir -p "${MOTIONEYE_DATA}/nginx/log"
[ ! -d "${MOTIONEYE_DATA}/nginx/ssl" ] && mkdir -p "${MOTIONEYE_DATA}/nginx/ssl"

if [ -f "${MOTIONEYE_DATA}/nginx/ssl/motioneye.crt.pem" ] && [ -f "${MOTIONEYE_DATA}/nginx/ssl/motioneye.crt.pem" ]
then
  MOTIONEYE_PORTS+=(
    --publish 8443:8443
  )
fi

MOTIONEYE_ID="$( docker container ls --quiet --all --filter "name=$MOTIONEYE_NAME" )"

if [ -n "$MOTIONEYE_ID" ]
then
  docker stop "$MOTIONEYE_ID"
  docker container rm "$MOTIONEYE_ID"
fi

docker pull "${MOTIONEYE_IMAGE}:${MOTIONEYE_TAG}"
docker run \
  --detach \
  "${MOTIONEYE_PORTS[@]}" \
  --name "$MOTIONEYE_NAME" \
  --hostname "$MOTIONEYE_NAME" \
  --restart "$MOTIONEYE_RESTART" \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume "${MOTIONEYE_DATA}/config:/etc/motioneye" \
  --volume "${MOTIONEYE_DATA}/log:/var/log/motioneye" \
  --volume "${MOTIONEYE_DATA}/media:/var/lib/motioneye" \
  --volume "${MOTIONEYE_DATA}/nginx/log:/var/log/nginx" \
  --volume "${MOTIONEYE_DATA}/nginx/ssl:/var/lib/nginx/ssl" \
  "${MOTIONEYE_IMAGE}:${MOTIONEYE_TAG}"

docker exec "$MOTIONEYE_NAME" /usr/sbin/logrotate --force /etc/logrotate.conf || :
