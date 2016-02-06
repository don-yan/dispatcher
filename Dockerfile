FROM httpd:2.4

VOLUME ["/etc/httpd/conf/certs"]

ENV PUBLISH_HOSTNAME ''
ENV PUBLISH_PORT 4503

ENV DISPATCHER_VERSION 4.1.11
ENV DISPATCHER_GZ_URL https://www.adobeaemcloud.com/content/companies/public/adobe/dispatcher/dispatcher/_jcr_content/top/download_10/file.res/dispatcher-apache2.4-linux-x86-64-$DISPATCHER_VERSION.tar.gz

RUN buildDeps='ca-certificates curl' set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& rm -r /var/lib/apt/lists/* \
  && curl -SL "$DISPATCHER_GZ_URL" -o dispatcher.tar.gz \
	&& mkdir -p src/dispatcher \
	&& tar -xvf dispatcher.tar.gz -C src/dispatcher \
	&& rm dispatcher.tar.gz* \
  && cp src/dispatcher/dispatcher-apache2.4-$DISPATCHER_VERSION.so $HTTPD_PREFIX/modules/mod_dispatcher.so \
  && rm -r src/dispatcher \
	&& apt-get purge -y --auto-remove $buildDeps

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./httpd-vhosts.conf conf/extra/httpd-vhosts.conf
COPY ./dispatcher.any /usr/local/apache2/conf/dispatcher.any
