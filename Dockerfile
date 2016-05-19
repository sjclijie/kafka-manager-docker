FROM anapsix/alpine-java:jdk8
# inpired by: https://github.com/prabhuinbarajan/kafka-manager-docker/

MAINTAINER Clement Laforet <sheepkiller@cultdeadsheep.org>

ENV JAVA_MAJOR=8
ENV JAVA_UPDATE=77
ENV JAVA_BUILD=03

ENV JAVA_HOME=/opt/jdk1.${JAVA_MAJOR}.0_${JAVA_UPDATE}
ENV KM_VERSION=1.3.0.8
ENV KM_REVISION=6e196ea7a332471bead747535f9676f0a2bad008
ENV KM_DIR=/kafka-manager-${KM_VERSION}
ENV KM_CFG="${KM_DIR}/conf/application.conf"

RUN apk add --no-cache git && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist

RUN cd /tmp/kafka-manager && \
    cp ./target/universal/kafka-manager-${KM_VERSION}.zip /tmp/ 
    
ENTRYPOINT ["sleep","100"]
