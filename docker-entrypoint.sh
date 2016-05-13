#!/bin/bash

[ $DEBUG ] && set -x

ZK_HOST=${ZK_HOST:-127.0.0.1}
ZK_PORT=${ZK_PORT:-2181}
ZK_HOSTS="${ZK_HOST}:${ZK_PORT}"


KM_USER=${KM_USER:-admin}
KM_PASS=${KM_PASS:-admin123465}
APPLICATION_SECRET="$KM_PASS"

for i in {30..0}; do
  if nc -w 1  -v $ZK_HOST $ZK_PORT; then
  break
  fi
  echo 'Connecting zookeeper server...'
  sleep 1
done

# modify config file
sed -i -r "s/(basicAuthentication.enabled)=.*/\1=true/" $KM_CFG
sed -i -r "s/(basicAuthentication.username)=.*/\1=$KM_USER/" $KM_CFG
sed -i -r "s/(basicAuthentication.password)=.*/\1=$KM_PASS/" $KM_CFG
sed -i -r "s/(kafka-manager.zkhosts)=.*/\1=$ZK_HOST:$ZK_PORT/" $KM_CFG

sleep ${PAUSE:-0}

cd $KM_DIR

exec ./bin/kafka-manager -Dconfig.file=${KM_CFG} "${KM_ARGS}" "${@}"
