# Demo scripts used for ES|QL Talk

Elasticsearch and Kibana added a brand new query language: ES|QL — coming with a new endpoint (`_query`) and a simplified syntax. It lets you refine your results one step at a time and adds new features like data enrichment and processing right in your query. And you can use it across the Elastic Stack — from the Elasticsearch API to Discover and Alerting in Kibana. But the biggest change is behind the scenes: Using a new compute engine that was built with performance in mind.
> Join us for an overview and a look at syntax and internals.

## Setup

### Run locally

Run Elastic Stack:

```sh
echo docker compose down -v
echo docker compose up
```

And run:

```sh
./setup.sh
```

### Run on cloud

If you are running a cluster or a serverless project on [elastic cloud](https://cloud.elastic.co),
you need to create a `.cloud` local file which contains:

```properties
ELASTICSEARCH_URL=<the elasticsearch url you can read from the cloud console>
KIBANA_URL=<just replace es by kb in the ELASTICSEARCH_URL>
API_KEY=<the generated api key>
```

To get an API Key, just open Kibana with the following URL:

```sh
source .cloud ; open $KIBANA_URL/app/management/security/api_keys
```

Run:

```sh
./setup.sh
```
