#!/bin/bash
ES_HOST=${ES_HOST:-127.0.0.1}
ES_PORT=${ES_PORT:-9200}
WORKERS=${ELASTICWORKERS:-1}
LUMBERJACK_PORT=${PORT:-5043}
SYSLOG_PORT=${PORT1:-514}

cat << EOF > /etc/logstash/conf.d/logstash.conf
input {
  syslog {
    type => syslog
    port => ${SYSLOG_PORT}
  }
  lumberjack {
    port => ${LUMBERJACK_PORT}

    ssl_certificate => "/opt/certs/logstash-forwarder.crt"
    ssl_key => "/opt/certs/logstash-forwarder.key"

    type => "$LUMBERJACK_TAG"
  }
  collectd {typesdb => ["/opt/collectd-types.db"]}
}
output {
  stdout {
      debug => true
  }

  elasticsearch_http {
      host => "$ES_HOST"
      port => "$ES_PORT"
      workers => $WORKERS
  }
}
EOF

exec java -jar /opt/logstash/logstash.jar agent -f /etc/logstash/conf.d -- web
