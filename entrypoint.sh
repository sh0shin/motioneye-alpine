#!/usr/bin/env ash
# vim: set ft=sh :

[ ! -f /etc/motioneye/motioneye.conf ] && \
  cp /motioneye/lib/python*/site-packages/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

chown -R motion:motion \
  /etc/motioneye \
  /var/lib/motioneye \
  /var/log/motioneye

exec su motion -s /bin/ash -c "source /motioneye/bin/activate && exec meyectl startserver -c /etc/motioneye/motioneye.conf -l"
