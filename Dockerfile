FROM debian:stable-slim

MAINTAINER Viking Tang <wctang@gmail.com>

USER root
RUN apt-get update -qq && \
    apt-get install -q -y --no-install-recommends gosu mime-support git-core && \
    apt-get install -q -y --no-install-recommends ghc cabal-install libghc-zlib-dev && \
    cd $HOME && git clone -c http.sslVerify=false https://github.com/jgm/gitit && cd gitit && \
    cabal update && cabal install --prefix=/usr/local --jobs --ghc-options="-rtsopts" --reorder-goals . && \
    apt-get autoremove --purge -q -y ghc cabal-install libghc-zlib-dev && \
    rm -rf $HOME/.cabal $HOME/gitit /usr/local/lib/* && \
    rm -rf /tmp/* /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/data"]
WORKDIR /data

CMD ["gitit", "-f", "/data/gitit.conf", "+RTS", "-I0", "-RTS"]	

