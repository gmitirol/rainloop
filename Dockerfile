FROM gmitirol/alpine38-php72:v1

LABEL maintainer="Martin Pircher <martin.pircher@i-med.ac.at>"

ENV RAINLOOP=1.12.1

EXPOSE 8080/tcp

CMD ["supervisord"]

RUN \
    apk add php7-iconv && \
    php-ext.sh enable 'curl iconv mcrypt' && \
    php-ext.sh enable 'pdo pdo_sqlite' && \
    php-ext.sh enable 'apcu ldap' && \
    setup-nginx.sh php /home/project/rainloop && \
    sed -i 's|listen 80;|listen 8080;|' /etc/nginx/conf.d/default.conf && \
    sed -i 's|try_files \$uri \$uri/ =404;|try_files \$uri \$uri/ /index.php?url=$uri;|' /etc/nginx/conf.d/default.conf && \
    sed -i 's|##PLACEHOLDER_CUSTOM_CONFIGURATION##|location ^~ /data { deny all; }|' /etc/nginx/conf.d/default.conf && \
    sed -i '/docker_realip/s/#//' /etc/nginx/conf.d/default.conf

WORKDIR "/home/project/rainloop"

RUN \
    wget -q https://github.com/RainLoop/rainloop-webmail/releases/download/v${RAINLOOP}/rainloop-community-${RAINLOOP}.zip && \
    unzip rainloop-community-${RAINLOOP}.zip && \
    rm rainloop-community-${RAINLOOP}.zip && \
    chown -R project.project . && \
    find . -type f -exec chmod 644 {} \; && \
    find . -type d -exec chmod 755 {} \;

RUN \
    sed -i 's|\[10,20,30,50,100\]|[10,15,20,30,50,100]|g' /home/project/rainloop/rainloop/v/1.12.1/static/js/*.js && \
    sed -i 's|\[10,20,30,50,100\]|[10,15,20,30,50,100]|g' /home/project/rainloop/rainloop/v/1.12.1/static/js/min/*.js

VOLUME ["/home/project/rainloop/data"]
