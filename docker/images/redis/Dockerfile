FROM debian:wheezy

RUN apt-get update
RUN apt-get install -y redis-server

ADD start /root/start
RUN chmod +x /root/start

ADD etc/redis/redis.conf /etc/redis/redis.conf

CMD ["/root/start"]

EXPOSE 6379