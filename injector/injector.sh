#!/bin/sh
source .env.sh

if [ -z "$API_KEY" ] ; then
	java -jar injector/injector-$INJECTOR_VERSION.jar \
		--es.host "$ELASTICSEARCH_URL" \
		--es.pass "$ELASTIC_PASSWORD" \
		--nb 100000
else
	java -jar injector/injector-$INJECTOR_VERSION.jar \
		--es.host "$ELASTICSEARCH_URL" \
		--es.apikey "$API_KEY" \
		--nb 100000
fi
