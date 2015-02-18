FROM debian:stable

RUN apt-get update
RUN apt-get install -y openjdk-7-jre-headless wget

ADD solr-4.10.2.tgz /opt

ADD start /root/start
RUN chmod +x /root/start
CMD ["/root/start"]

EXPOSE 8983