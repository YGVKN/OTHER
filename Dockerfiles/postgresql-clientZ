FROM alpine
MAINTAINER YGVKN
LABEL YGVKN ZHUZHA
RUN apk add --no-cache --update \
        postgresql-client  && rm -rf /var/cache/apk/*
WORKDIR /
HEALTHCHECK --interval=8m --timeout=4s CMD cat /etc/*release* > /tmp/health_check || exit 1
STOPSIGNAL SIGTERM
ENTRYPOINT ["psql"]
#ENTRYPOINT ["tail"]
#CMD ["-f", "/dev/null","2>&1"]
