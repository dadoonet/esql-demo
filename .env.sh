source .env

if [ -e .cloud ] ; then
	source .cloud

	if [ -z "$ELASTICSEARCH_URL" ] || [ -z "$KIBANA_URL" ] || [ -z "$API_KEY" ] ; then
    echo ".cloud file is incorrect. It must contain:"
    echo "ELASTICSEARCH_URL=<Elasticsearch URL>"
    echo "KIBANA_URL=<Kibana URL>"
		echo "API_KEY=<API Key>"
	  echo "Falling back to local configuration."
		ELASTICSEARCH_URL=https://localhost:9200
		KIBANA_URL=http://localhost:5601
		CURL_OPTION="--insecure -H 'Content-Type: application/json' -u elastic:$ELASTIC_PASSWORD"
	else
		CURL_OPTION="--header 'Authorization: ApiKey $API_KEY' -H 'Content-Type: application/json'"
	fi
else
  echo ".cloud file does not exist. Falling back to local configuration."
	ELASTICSEARCH_URL=https://localhost:9200
	KIBANA_URL=http://localhost:5601
	CURL_OPTION="--insecure -H 'Content-Type: application/json' -u elastic:$ELASTIC_PASSWORD"
fi
