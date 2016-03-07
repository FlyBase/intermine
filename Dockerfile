FROM debian:jessie
MAINTAINER Josh Goodman <jogoodma@indiana.edu>

# TODO Look into using the ambassador pattern to avoid hard linking containers.
# https://docs.docker.com/engine/admin/ambassador_pattern_linking/
#
# Instead of linking like this.
#-------------------------------
#
# build server -> DB server
#           \         ^
#            \        |
#             \-> tomcat server
# 
# We would do something like this.
#
# build server ----------> (ambassador) -> DB server
#           \                   ^
#      (ambassador)             |
#            \                  |
#             \----------> tomcat server
#
# The issue with the first method is that the containers cannot
# be relinked if you need to rebuild one for some reason.
#-------------------------------

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
        postgresql-client \
        less \
        vim

RUN mkdir -p /intermine /home/intermine/.intermine /data

COPY bio /intermine/bio/
COPY config /intermine/config/
COPY imbuild /intermine/imbuild/
COPY intermine /intermine/intermine/
COPY flybasemine /intermine/flybasemine/
RUN rm -f /intermine/flybasemine/flybasemine.properties
COPY LICENSE /intermine/
COPY LICENSE.LIBS /intermine/
COPY README.md /intermine/
COPY RELEASE_NOTES /intermine/
COPY flybasemine/flybasemine.properties /home/intermine/.intermine/
RUN chown -R intermine:intermine /intermine /home/intermine/.intermine/

USER intermine

ENV ANT_OPTS="-server -XX:MaxPermSize=256M -Xmx1700m -XX:+UseParallelGC -Xms1700m -XX:SoftRefLRUPolicyMSPerMB=1 -XX:MaxHeapFreeRatio=99"
ENV JAVA_OPTS="$JAVA_OPTS -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"


VOLUME /intermine /home/intermine /data
WORKDIR /intermine
