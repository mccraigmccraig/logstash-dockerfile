# Logstash
#
# logstash is a tool for managing events and logs
#
# VERSION               1.3.3

FROM      dockerfile/ubuntu
MAINTAINER craig mcmillan "craig@trampolinesystems.com"

ENV DEBIAN_FRONTEND noninteractive

# What tag to use for lumberjack
ENV LUMBERJACK_TAG MYTAG

# Number of elasticsearch workers
ENV ELASTICWORKERS 1

RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb http://packages.elasticsearch.org/logstash/1.3/debian stable main" > /etc/apt/sources.list.d/logstash.list
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y wget openjdk-7-jre-headless
RUN apt-get install -y logstash

ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

RUN mkdir /opt/certs/
ADD certs/logstash-forwarder.crt /opt/certs/logstash-forwarder.crt
ADD certs/logstash-forwarder.key /opt/certs/logstash-forwarder.key
ADD collectd-types.db /opt/collectd-types.db

# EXPOSE 514
EXPOSE 5043
# EXPOSE 9200
# EXPOSE 9292
# EXPOSE 9300

CMD /usr/local/bin/run.sh
