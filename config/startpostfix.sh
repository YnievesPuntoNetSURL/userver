#!/bin/bash
trap "postfix stop" SIGINT
trap "postfix stop" SIGTERM
trap "postfix reload" SIGHUP

cp /etc/hosts /var/spool/postfix/etc/hosts

mkdir -p /var/spool/postfix/pid

postfix check

postfix start

sleep 3

while kill -0 "`cat /var/spool/postfix/pid/master.pid`"; do
  sleep 5
done