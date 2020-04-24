FROM gmitirol/alpine311-php73:v1
LABEL maintainer="Martin Pircher <martin.pircher@i-med.ac.at>"

# rainloop version
ENV RAINLOOP=1.12.1

# default port
EXPOSE 8080/tcp

# run supervisord
CMD ["supervisord"]

# setup php+nginx
RUN \
    apk add --no-cache php7-iconv && \
    rm -rf /var/cache/apk/* && \
    php-ext.sh enable 'curl iconv mcrypt' && \
    php-ext.sh enable 'pdo pdo_sqlite' && \
    php-ext.sh enable 'opcache apcu ldap' && \
    setup-nginx.sh php /home/project/rainloop && \
    sed -i 's|listen 80;|listen 8080;|' /etc/nginx/conf.d/default.conf && \
    sed -i 's|try_files \$uri \$uri/ =404;|try_files \$uri \$uri/ /index.php?url=$uri;|' /etc/nginx/conf.d/default.conf && \
    sed -i 's|##PLACEHOLDER_CUSTOM_CONFIGURATION##|location ^~ /data { deny all; }|' /etc/nginx/conf.d/default.conf && \
    sed -i '/docker_realip/s/#//' /etc/nginx/conf.d/default.conf && \
    sed -i 's|;opcache.memory_consumption=128|opcache.memory_consumption=64|' /etc/php7/php.ini && \
    sed -i 's|;opcache.max_accelerated_files=10000|opcache.max_accelerated_files=1000|' /etc/php7/php.ini && \
    sed -i 's|;opcache.validate_timestamps=1|opcache.validate_timestamps=0|' /etc/php7/php.ini && \
    sed -i 's|;opcache.interned_strings_buffer=8|opcache.interned_strings_buffer=16|' /etc/php7/php.ini && \
    sed -i 's|post_max_size = 8M|post_max_size = 20M|' /etc/php7/php.ini && \
    sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 20M|' /etc/php7/php.ini

WORKDIR "/home/project/rainloop"

# install rainloop
RUN \
    curl -o rainloop.zip -L https://github.com/RainLoop/rainloop-webmail/releases/download/v${RAINLOOP}/rainloop-community-${RAINLOOP}.zip && \
    unzip rainloop.zip && \
    rm rainloop.zip && \
    chown -R project.project . && \
    find . -type f -exec chmod 644 {} \; && \
    find . -type d -exec chmod 755 {} \; && \
    sed -i 's|\[10,20,30,50,100\]|[10,15,20,30,50,100]|g' /home/project/rainloop/rainloop/v/1.12.1/static/js/*.js && \
    sed -i 's|\[10,20,30,50,100\]|[10,15,20,30,50,100]|g' /home/project/rainloop/rainloop/v/1.12.1/static/js/min/*.js

VOLUME ["/home/project/rainloop/data"]
