FROM debian:jessie

MAINTAINER Josh Goodman <jogoodma@indiana.edu>

RUN apt-get update && apt-get install -y \
        default-jdk \
        perl \
        ant \
        tomcat8 \
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
        libperl6-junction-perl


RUN mkdir /intermine

COPY bio /intermine/bio/
COPY config /intermine/config/
COPY imbuild /intermine/imbuild/
COPY intermine /intermine/intermine/
COPY LICENSE /intermine/
COPY LICENSE.LIBS /intermine/
COPY README.md /intermine/
COPY RELEASE_NOTES /intermine/

