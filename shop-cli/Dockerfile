FROM php:8.1-cli

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \    
    gnupg2 \
    curl \ 
    bash \
	less \
	mariadb-client 

# PF certificates
#RUN mkdir /tmp/pfcerts && \
#    curl --silent --insecure https://repo.pnet.ch/artifactory/linux-generic-local/certificates/pki-all.tar | tar -C /tmp/pfcerts -x && \
#    cd /tmp/pfcerts && \
#    for f in *.pem; do mv -- "$f" "${f%.pem}.crt"; done && \
#    mv *.crt /usr/local/share/ca-certificates && \
#    cd ~ && \
#    rm -rf /tmp/pfcerts && \
RUN  update-ca-certificates

RUN set -ex; \
	mkdir -p /var/www/html; \
	chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libpng-dev \
		libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	; \
	docker-php-ext-install -j "$(nproc)" \
		bcmath \
		exif \
		gd \
		intl \
		mysqli \
		zip \
	; \
# https://pecl.php.net/package/imagick
#	pecl install imagick-3.6.0; \
#	docker-php-ext-enable imagick; \
#	rm -r /tmp/pear; \
#	\
# some misbehaving extensions end up outputting to stdout 🙈 (https://github.com/docker-library/wordpress/issues/669#issuecomment-993945967)
	out="$(php -r 'exit(0);')"; \
	[ -z "$out" ]; \
	err="$(php -r 'exit(0);' 3>&1 1>&2 2>&3)"; \
	[ -z "$err" ]; \
	\
	extDir="$(php -r 'echo ini_get("extension_dir");')"; \
	[ -d "$extDir" ]; \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$extDir"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	! { ldd "$extDir"/*.so | grep 'not found'; }; \
# check for output like "PHP Warning:  PHP Startup: Unable to load dynamic library 'foo' (tried: ...)
	err="$(php --version 3>&1 1>&2 2>&3)"; \
	[ -z "$err" ]

RUN { \
# https://www.php.net/manual/en/errorfunc.constants.php
# https://github.com/docker-library/wordpress/issues/420#issuecomment-517839670
		echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
		echo 'display_errors = Off'; \
		echo 'display_startup_errors = Off'; \
		echo 'log_errors = On'; \
		echo 'error_log = /dev/stderr'; \
		echo 'log_errors_max_len = 1024'; \
		echo 'ignore_repeated_errors = On'; \
		echo 'ignore_repeated_source = Off'; \
		echo 'html_errors = Off'; \
	} > /usr/local/etc/php/conf.d/error-logging.ini

ENV WORDPRESS_CLI_GPG_KEY 63AF7AA15067C05616FDDD88A3A2E8F226F0BC06
ENV WORDPRESS_CLI_VERSION 2.6.0
ENV WORDPRESS_CLI_SHA512 d73f9161a1f03b8ecaac7b196b6051fe847b3c402b9c92b1f6f3acbe5b1cf91f7260c0e499b8947bab75920ecec918b39533ca65fa5a1fd3eb6ce7b8e2c58e7d


# current pgp key can not be found on keyserver.ubuntu.com
#RUN set -ex; \
#    apk add --no-cache --virtual .fetch-deps \
#    gnupg; \ 
#	\
#	curl -o /usr/local/bin/wp.gpg -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar.gpg"; \
#	\
#	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \ 
#	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$WORDPRESS_CLI_GPG_KEY"; \
 #       gpg --batch --decrypt --output /usr/local/bin/wp /usr/local/bin/wp.gpg; \
#	gpgconf --kill all; \
#	rm -rf "$GNUPGHOME" /usr/local/bin/wp.gpg; unset GNUPGHOME; \
#	\
#	echo "$WORDPRESS_CLI_SHA512 */usr/local/bin/wp" | sha512sum -c -; \
#	chmod +x /usr/local/bin/wp; \
#	\
#	apk del --no-network .fetch-deps; \
#	\
#	wp --allow-root --version

RUN  curl -o /usr/local/bin/wp -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar"; \
     chmod +x /usr/local/bin/wp; \
     wp --allow-root --version

VOLUME /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/

USER www-data

ENV WORDPRESS_HOME /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["wp", "shell"]