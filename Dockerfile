FROM alpine

RUN wget https://github.com/pymumu/smartdns/releases/download/Release33/smartdns.1.2020.09.08-2235.x86_64-linux-all.tar.gz \
  && tar zxvf smartdns.*.tar.gz \
  && mv smartdns/usr/sbin/smartdns /bin/smartdns \
  && chmod +x /bin/smartdns \
  && rm -rf smartdns* \
  && apk add --no-cache --virtual .build-deps ca-certificates curl unzip

ADD smartdns.conf /smartdns.conf
ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh
RUN apk del .build-deps \
	&& echo '0 9 * * 1 bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install' >> /var/spool/cron/crontabs/root