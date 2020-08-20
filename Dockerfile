FROM alpine:edge

RUN apk update && apk add 'tor' --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  --allow-untrusted haproxy ruby privoxy obfs4proxy

RUN apk --update add --virtual build-dependencies ruby-bundler ruby-dev \
  && apk add ruby-nokogiri --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
  && gem install --no-document socksify \
  && apk del build-dependencies

ADD torrc.erb       /usr/local/etc/torrc.erb
ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb
ADD privoxy.cfg.erb /usr/local/etc/privoxy.cfg.erb

ADD start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

EXPOSE 2090 8118 5566

CMD syslogd && ruby /usr/local/bin/start.rb
