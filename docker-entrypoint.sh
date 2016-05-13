#!/bin/bash

[ $DEBUG ] && set -x

ZK_HOST=${ZK_HOST:-127.0.0.1}
ZK_PORT=${ZK_PORT:-2182}
ZK_HOSTS="$ZK_HOST:$ZK_PORT"
APPLICATION_SECRET="$KM_PASS"

for i in {30..0}; do
  if nc -w 1  -v $ZK_HOST $ZK_PORT; then
  break
  fi
  echo 'Connecting zookeeper server...'
  sleep 1
done

sleep ${PAUSE:-0}

cd /kafka-manager-${KM_VERSION}

exec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"
