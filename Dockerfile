FROM debian:jessie

MAINTAINER Josh Goodman <jogoodma@indiana.edu>

ENV TOMCAT_MAJOR_VER 7
ENV TOMCAT_VERSION 7.0.68


RUN groupadd intermine && useradd -g intermine intermine

RUN apt-get update && apt-get install -y \
        wget \
        ca-certificates \
        default-jdk

RUN wget http://apache.mirrors.pair.com/tomcat/tomcat-${TOMCAT_MAJOR_VER}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar zxvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} tomcat && \
    rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz

RUN chown -R intermine:intermine /tomcat 

USER intermine

COPY config/tomcat-users.xml /tomcat/conf/tomcat-users.xml

RUN sed -ri -e 's|<Context>|<Context sessionCookiePath="/" useHttpOnly="false" clearReferencesStopTimerThreads="true">|g' /tomcat/conf/context.xml
RUN sed -ri -e 's|<Connector (.*)$|<Connector URIEncoding="UTF-8" \1|g' /tomcat/conf/server.xml

ENV ANT_OPTS="-server -XX:MaxPermSize=256M -Xmx1700m -XX:+UseParallelGC -Xms1700m -XX:SoftRefLRUPolicyMSPerMB=1 -XX:MaxHeapFreeRatio=99"
ENV JAVA_OPTS="$JAVA_OPTS -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"
ENV TOMCAT_OPTS="-Xmx256m -Xms128m"

EXPOSE 8080

VOLUME /tomcat 

ENTRYPOINT ["/tomcat/bin/catalina.sh"]
CMD ["--help"]

