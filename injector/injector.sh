#!/bin/sh
source .env.sh

java -jar injector/injector-$INJECTOR_VERSION.jar \
  --debug \
	--es.host $ELASTICSEARCH_URL \
	--es.pass $ELASTIC_PASSWORD \
	--nb 100000
