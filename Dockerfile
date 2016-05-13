FROM anapsix/alpine-java:jdk8
# inpired by: https://github.com/prabhuinbarajan/kafka-manager-docker/

MAINTAINER Clement Laforet <sheepkiller@cultdeadsheep.org>

ENV JAVA_MAJOR=8 \
    JAVA_UPDATE=77 \
    JAVA_BUILD=03

ENV JAVA_HOME=/opt/jdk1.${JAVA_MAJOR}.0_${JAVA_UPDATE} \
    KM_VERSION=1.3.0.8 \
    KM_REVISION=6e196ea7a332471bead747535f9676f0a2bad008 \
    KM_CONFIGFILE="conf/application.conf"
    
ENV ZK_HOST=${ZK_HOST:-127.0.0.1} \
    ZK_PORT=${ZK_PORT:-2182} \
    ZK_HOSTS=${ZK_HOST}:${ZK_PORT}
    
ENV APPLICATION_SECRET=${KM_PASS}

RUN apk add --no-cache git && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist

RUN cd /tmp/kafka-manager && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    rm -fr /kafka-manager-${KM_VERSION}/share

RUN apk add --no-cache wget curl netcat-openbsd && apk del git

ADD docker-entrypoint.sh /kafka-manager-${KM_VERSION}/

RUN chmod +x /kafka-manager-${KM_VERSION}/docker-entrypoint.sh

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]
