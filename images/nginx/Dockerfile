FROM debian:wheezy

RUN apt-get update
RUN apt-get install -y nginx

ADD start /root/start
ADD etc/nginx/sites-available/default /etc/nginx/sites-available/default

RUN chmod +x /root/start

VOLUME [ "/var/www", "/home" ]
CMD ["/root/start"]

EXPOSE 80
EXPOSE 443

