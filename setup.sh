source .env.sh

# Script properties
INJECTOR_FILE="injector-$INJECTOR_VERSION.jar"
INJECTOR_DOWNLOAD_URL="https://repo1.maven.org/maven2/fr/pilato/elasticsearch/injector/injector/$INJECTOR_VERSION/$INJECTOR_FILE"

# Utility functions
check_service () {
	echo '\n'
	echo "$1 $STACK_VERSION must be available on $2"
	echo "⏳ Waiting for $1"

	until curl $CURL_OPTION -u elastic:$ELASTIC_PASSWORD -s "$2" | grep "$3" > /dev/null; do
		  sleep 1
			echo '.'
	done

	echo '\n'
	echo "✅ $1 is now up."
}

# Start of the script
echo "Installation script for ES|QL demo with Elastic $STACK_VERSION"

echo "##################"
echo "### Pre-checks ###"
echo "##################"

if [ -z "$CLOUD_ID" ] ; then
	echo "We are running a local demo. If you did not start Elastic yet, please run:"
	echo "docker-compose up"
fi

check_service "Elasticsearch" "$ELASTICSEARCH_URL" "\"number\" : \"$STACK_VERSION\""
check_service "Kibana" "$KIBANA_URL/app/home#/" "<title>Elastic</title>"

echo '\n'
echo "###############################"
echo "### Install Person Injector ###"
echo "###############################"
echo '\n'

echo "Download person injector"
if [ ! -e injector/$INJECTOR_FILE ] ; then
  cd injector
  wget --no-check-certificate $INJECTOR_DOWNLOAD_URL
  cd -
fi

echo '\n'
echo "################################"
echo "### Configure Cloud Services ###"
echo "################################"
echo '\n'

echo "Remove existing person data"
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/person*" -u elastic:$ELASTIC_PASSWORD ; echo

echo "Remove existing person-policy enrich policy"
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/_enrich/policy/person-policy" -u elastic:$ELASTIC_PASSWORD ; echo

echo '\n'
echo "#############################"
echo "### Inject Person Dataset ###"
echo "#############################"
echo '\n'

echo "Injecting person dataset"
injector/injector.sh

echo "Add David to the dataset"
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/person/_doc/1" -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" -d'
{
  "name": "David Pilato",
  "dateOfBirth": "1971-12-26",
  "gender": "male",
  "children": 3,
  "marketing": {
    "cars": 10,
    "music": 876
  },
  "address": {
    "country": "France",
    "zipcode": "95800",
    "city": "Cergy",
    "countrycode": "FR",
    "location": {
      "lon": 2.0173375,
      "lat": 49.040818
    }
  }
}' ; echo

echo "Add some data about persons"
curl $CURL_OPTION -XDELETE "$ELASTICSEARCH_URL/info" -u elastic:$ELASTIC_PASSWORD ; echo
curl $CURL_OPTION -XPUT "$ELASTICSEARCH_URL/info/_doc/1" -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" -d'
{
  "id": "1",
  "height": 1.79,
  "weight": 91
}'; echo


echo '\n'
echo "########################"
echo "### ✅ Demo is ready ###"
echo "########################"
echo '\n'

open "$KIBANA_URL/app/dev_tools#/console"
open "$KIBANA_URL/app/management/data/index_management/enrich_policies"
