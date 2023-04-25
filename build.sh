#!/usr/bin/env bash
# vim: set ft=sh syn=bash :
# shellcheck shell=bash

set -eu -o pipefail

docker buildx build --push --platform linux/arm64,linux/amd64,linux/arm/v7 --tag sh0shin/motioneye-alpine:devel .
