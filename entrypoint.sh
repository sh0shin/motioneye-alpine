#!/usr/bin/env ash
# vim: set ft=sh :

[ ! -f /etc/motioneye/motioneye.conf ] && \
  cp /motioneye/lib/python*/site-packages/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

[ ! -d /var/lib/nginx/ssl ] && mkdir -m 0700 /var/lib/nginx/ssl

chown -R motion:motion \
  /etc/motioneye \
  /var/lib/motioneye \
  /var/log/motioneye

if [ -f /var/lib/nginx/ssl/motioneye.pem ]
then
  cp /motioneye/nginx-motioneye-ssl.conf /etc/nginx/http.d/
else
  cp /motioneye/nginx-motioneye.conf /etc/nginx/http.d/
fi

chown -R nginx:nginx \
  /var/lib/nginx/ssl \
  /var/log/nginx

nginx -t && nginx

exec su motion -s /bin/ash -c "source /motioneye/bin/activate && exec meyectl startserver -c /etc/motioneye/motioneye.conf -l"
