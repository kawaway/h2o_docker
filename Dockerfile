FROM ubuntu:16.04

RUN	apt-get update && \
	apt-get install -y \
	gcc \
	g++ \
	make \
	llvm-5.0 \
	clang-5.0 \
	cmake \
	autoconf \
	perl \
	ruby \
	git \
	bison \
	zlib1g \
	zlib1g-dev \
	openssl \
	libssl-dev

RUN	cd /tmp && \
	git clone https://github.com/h2o/h2o.git && \
	cd h2o && \
	git checkout -b latest_20180313 0a42b42 && \
	cmake . && \
	make && \
	make install && \
	cd .. && \
	rm -rf h2o

RUN	groupadd www && useradd -m -d /usr/www -g www www
USER	www
WORKDIR	/usr/www

RUN	mkdir -p conf && \
	mkdir -p tls && \
	mkdir -p doc_root && \
	mkdir -p share/h2o && \
	mkdir -p mruby && \
	cp -r /usr/local/share/h2o/* share/h2o && \
	cp    /usr/local/share/doc/h2o/examples/h2o/server.key tls && \
	cp    /usr/local/share/doc/h2o/examples/h2o/server.crt tls

# H2O run as root for bind port:80/443(require CAP_NET_BIND_SERVICE, cause EACCES) first. then www by setuid
USER	root
ENV	H2O_ROOT=/usr/www
CMD	["h2o", "-m", "master", "-c", "/usr/www/conf/h2o.conf"]	

