#!/bin/bash

[ $DEBUG ] && set -x

for i in {30..0}; do
  if nc -w 1  -v $ZK_HOST $ZK_PORT; then
  break
  fi
  echo 'Connecting zookeeper server...'
  sleep 1
done

sleep ${PAUSE:0}

exec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"
