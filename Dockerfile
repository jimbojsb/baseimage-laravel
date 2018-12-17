FROM alpine:3.8

ENV PATH $PATH:/app/vendor/bin:/app:/app/node_modules/.bin
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV APP_ENV production

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["runsvinit"]


RUN apk add --update --no-cache \
    bash \
    runit \
    nginx \
    curl \
    php7 \
    php7-mysqlnd \
    php7-pdo \
    php7-pdo_mysql \
    php7-xdebug \
    php7-fpm \
    php7-zip \
    php7-mbstring \
    php7-imagick \
    php7-xml \
    php7-json \
    php7-dom \
    git \
    php7-phar \
    php7-bcmath \
    php7-curl \
    php7-session \
    php7-tokenizer \
    php7-xmlwriter \
    php7-fileinfo \
    nodejs \
    npm

COPY bin/ /usr/local/bin/
COPY etc/ /etc/
COPY root/ /root/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

ONBUILD COPY ./composer-auth.json /root/.composer/auth.json
ONBUILD COPY composer* package* /app/
ONBUILD RUN composer install --no-scripts --no-plugins --no-autoloader --no-dev && composer clear-cache
ONBUILD RUN npm install
ONBUILD COPY . /app
ONBUILD RUN composer -o dump-autoload
ONBUILD RUN npm run production