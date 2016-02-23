FROM debian:jessie

MAINTAINER Josh Goodman <jogoodma@indiana.edu>

RUN groupadd intermine && useradd -m -g intermine intermine

RUN apt-get update && apt-get install -y \
        wget \
        ca-certificates \
        default-jdk \
        perl \
        ant \
        git \
        liblist-moreutils-perl \
        libwww-perl \
        libmodule-find-perl \
        libmoose-perl \
        libmoosex-role-withoverloading-perl \
        libmoosex-types-perl \
        libtext-csv-xs-perl \
        liburi-perl \
        libxml-perl \
        libxml-dom-perl \
        libtext-glob-perl \
        liblog-handler-perl \
        libdatetime-perl \
        libweb-scraper-perl \
        libouch-perl \
        libnumber-format-perl \
        libperlio-gzip-perl \
        libperl6-junction-perl \
        postgresql-client

RUN mkdir -p /intermine && \
    chown -R intermine:intermine /intermine

USER intermine

COPY bio /intermine/bio/
COPY config /intermine/config/
COPY imbuild /intermine/imbuild/
COPY intermine /intermine/intermine/
COPY flybasemine /intermine/flybasemine/
COPY LICENSE /intermine/
COPY LICENSE.LIBS /intermine/
COPY README.md /intermine/
COPY RELEASE_NOTES /intermine/

ENV ANT_OPTS="-server -XX:MaxPermSize=256M -Xmx1700m -XX:+UseParallelGC -Xms1700m -XX:SoftRefLRUPolicyMSPerMB=1 -XX:MaxHeapFreeRatio=99"
ENV JAVA_OPTS="$JAVA_OPTS -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"

VOLUME /intermine
WORKDIR /intermine
