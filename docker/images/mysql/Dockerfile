FROM debian:wheezy

RUN apt-get update
RUN apt-get install -y mysql-server

ADD start /root/start
ADD etc/mysql/my.cnf /etc/mysql/my.cnf
RUN chmod +x /root/start

CMD ["/root/start"]

EXPOSE 3306
