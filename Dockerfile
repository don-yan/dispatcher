FROM httpd:2.4

VOLUME ["/etc/httpd/conf/certs"]
VOLUME ["/usr/local/apache2/logs"]

ENV SERVER_NAME ''

ENV DISPATCHER_VERSION 4.1.12
ENV DISPATCHER_GZ_URL https://www.adobeaemcloud.com/content/companies/public/adobe/dispatcher/dispatcher/_jcr_content/top/download_10/file.res/dispatcher-apache2.4-linux-x86-64-ssl10-$DISPATCHER_VERSION.tar.gz

RUN buildDeps='ca-certificates curl' set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& rm -r /var/lib/apt/lists/* \
	&& curl -SL "$DISPATCHER_GZ_URL" -o dispatcher.tar.gz \
	&& mkdir -p src/dispatcher \
	&& tar -xvf dispatcher.tar.gz -C src/dispatcher \
	&& rm dispatcher.tar.gz* \
	&& cp src/dispatcher/dispatcher-apache2.4-*.so $HTTPD_PREFIX/modules/mod_dispatcher.so \
	&& rm -r src/dispatcher \
	&& apt-get purge -y --auto-remove $buildDeps

RUN ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/libssl.so.0.9.8 \
	&& ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/libcrypto.so.0.9.8

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./dispatcher.any /usr/local/apache2/conf/dispatcher.any

RUN mkdir -p /opt/communique/dispatcher \
	&& chown daemon:daemon /opt/communique/dispatcher \
	&& chmod 755 /opt/communique/dispatcher
