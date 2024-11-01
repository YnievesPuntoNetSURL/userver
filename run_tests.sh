#!/usr/bin/env sh
apk --no-cache add curl

until curl --silent --fail http://app | grep 'PHP'; do
  echo "Waitting  for PHP to start..."
  sleep 2
done