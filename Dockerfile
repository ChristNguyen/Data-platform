FROM docker-dso.msb.com.vn/trinodb/trino:420

COPY ./trino/plugin/ /usr/lib/trino/plugin
COPY ./trino/etc/certs/ /etc/certs/

RUN mkdir -p /data/trino/

RUN chmod -R 777 /data/trino/