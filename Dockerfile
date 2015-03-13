#
FROM muccg/python-base:debian8-2.7
MAINTAINER ccg <ccgdevops@googlegroups.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
  openjdk-7-jre-headless wget unzip && \
  mkdir /usr/local/closure && \
  cd /usr/local/closure && \
  wget http://dl.google.com/closure-compiler/compiler-latest.zip && \
  unzip compiler-latest.zip && \
  rm -f compiler-latest.zip && \
  chmod 644 compiler.jar && \
  apt-get remove -y --purge wget unzip && \
  apt-get autoremove -y --purge && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install "closure-linter==2.3.13"

VOLUME ["/data"]

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD /docker-entrypoint.sh
