#!/bin/sh
source hono.env

# Hono endpoint
export HONO_EP=https://10.111.104.103:28443

# Tenant configuration
export TENANT=iplonian

# Kafka IP (example, replace with your actual Kafka service IP)
export KAFKA_IP=10.99.3.140  # Replace with actual Kafka service IP

# Truststore path
export TRUSTSTORE_PATH=/tmp/truststore.pem

# Set the environment variables for connections and curl options
export APP_OPTIONS="-H ${KAFKA_IP} -P 9094 -u hono -p hono-secret --ca-file ${TRUSTSTORE_PATH} --disable-hostname-verification"
export CURL_OPTIONS="--insecure"
export MOSQUITTO_OPTIONS="--cafile ${TRUSTSTORE_PATH} --insecure"

# Create the tenant with AMQP messaging type
curl -i -X POST $CURL_OPTIONS -H 'accept: application/json' -H 'Content-Type: application/json' --data-binary '{"ext": {"messaging-type": "amqp"}}' $HONO_EP/v1/tenants/$TENANT || { echo "Failed to create tenant"; exit 1; }

echo "Tenant creation successful!"
