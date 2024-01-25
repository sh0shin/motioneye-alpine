#!/usr/bin/env ash
# vim: set ft=sh :

[ ! -f /etc/motioneye/motioneye.conf ] && \
  cp /motioneye/lib/python*/site-packages/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

[ ! -d /var/lib/nginx/ssl ] && mkdir -m 0700 /var/lib/nginx/ssl

chown -R motion:motion \
  /etc/motioneye \
  /var/lib/motioneye \
  /var/log/motioneye

if [ -f /var/lib/nginx/ssl/motioneye.crt.pem ] && [ -f /var/lib/nginx/ssl/motioneye.key.pem ]
then
  cp /motioneye/nginx-motioneye-ssl.conf /etc/nginx/http.d/
  [ ! -f /var/lib/nginx/ssl/dhparam.pem ] && openssl dhparam -out /var/lib/nginx/ssl/dhparam.pem 2048
else
  cp /motioneye/nginx-motioneye.conf /etc/nginx/http.d/
fi

chown -R nginx:nginx \
  /var/log/nginx

crond
nginx -t && nginx

# podman-freebsd
case "$( uname -v )"
in
  FreeBSD*)
    chmod +s /usr/bin/python3.*
    sed -i 's/worker_processes auto;/worker_processes 1;/g' /etc/nginx/nginx.conf
  ;;
esac

exec su motion -s /bin/ash -c "source /motioneye/bin/activate && exec meyectl startserver -c /etc/motioneye/motioneye.conf -l"
