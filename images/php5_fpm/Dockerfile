FROM debian:jessie

RUN apt-get update
RUN apt-get install -y curl
RUN curl http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN echo "deb http://mirror.proserve.nl/debian/ jessie main" > /etc/apt/sources.list
RUN echo "deb http://packages.dotdeb.org jessie all"        > /etc/apt/sources.list.d/dotdeb.list
RUN echo "deb-src http://packages.dotdeb.org jessie all"    >> /etc/apt/sources.list.d/dotdeb.list
RUN apt-get update

RUN apt-get install -y      \
    php5-fpm/jessie         \
    php5-mysql              \
    php5-curl               \
    php5-apcu               \
    php5-xdebug             \
    php5-intl               \
    php5-redis              \
    php5-sqlite             \
    php5-gd                 \
    redis-server            \
    redis-tools             \
;


ADD start /root/start
RUN chmod +x /root/start

ADD etc/php5/fpm/pool.d/www.conf    /etc/php5/fpm/pool.d/www.conf
ADD etc/php5/conf.d/40-commons.ini  /etc/php5/conf.d/40-commons.ini
ADD etc/php5/conf.d/40-commons.ini  /etc/php5/fpm/conf.d/40-commons.ini

CMD ["/root/start"]

EXPOSE 9000
