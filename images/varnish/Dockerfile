FROM debian:stable

RUN apt-get update
RUN apt-get install -y      \
    varnish

ADD etc/varnish/default.vcl /etc/varnish/default.vcl
ADD etc/default/varnish     /etc/default/varnish

ADD start /root/start
RUN chmod +x /root/start

CMD ["/root/start"]

EXPOSE 81