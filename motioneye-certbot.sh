#!/usr/bin/env bash
# vim: set ft=sh syn=bash :
# shellcheck shell=bash

set -eu -o pipefail

CERTBOT_DOMAIN="${1:-}"
MOTIONEYE_DATA="/data/motioneye"

if [ -z "$CERTBOT_DOMAIN" ]
then
  read -r -p "Domain: " CERTBOT_DOMAIN
fi

if [ -d "/etc/letsencrypt/live/${CERTBOT_DOMAIN}" ]
then
  certbot certonly --standalone --register-unsafely-without-email --agree-tos --keep-until-expiring --domain "$CERTBOT_DOMAIN"
else
  certbot certonly --standalone --register-unsafely-without-email --agree-tos --domain "$CERTBOT_DOMAIN"
fi

cp -aL "/etc/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem" "${MOTIONEYE_DATA}/nginx/ssl/motioneye.key.pem"
cp -aL "/etc/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem" "${MOTIONEYE_DATA}/nginx/ssl/motioneye.crt.pem"
