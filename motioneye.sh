#!/usr/bin/env sh

[ ! -d /data/motioneye/config ] && mkdir -p /data/motioneye/config
[ ! -d /data/motioneye/log ] && mkdir -p /data/motioneye/log
[ ! -d /data/motioneye/video ] && mkdir -p /data/motioneye/video

docker stop motioneye
docker container rm motioneye

docker pull sh0shin/motioneye-alpine:edge 
docker run \
  --detach \
  --publish 8765:8765 \
  --name="motioneye" \
  --hostname="motioneye" \
  --restart "always" \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume "/data/motioneye/config:/etc/motioneye" \
  --volume "/data/motioneye/log:/var/log/motioneye" \
  --volume "/data/motioneye/video:/var/lib/motioneye" \
  sh0shin/motioneye-alpine:edge
