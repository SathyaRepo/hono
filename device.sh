#!/bin/sh
source hono.env

# Hono endpoint
export HONO_EP=https://10.111.104.103:28443

# Tenant and Device configuration
export TENANT=iplonian
export DEVICE_ID=iplonian:deviceone  # Set your own device name here
export AUTH_ID=iplon_deviceone
export PWD=iplon@iot6

# Kafka IP (example, replace with your actual Kafka service IP)
export KAFKA_IP=10.111.104.103  # Replace with actual Kafka service IP

# Truststore path
export TRUSTSTORE_PATH=/tmp/truststore.pem

# Set the environment variables for connections and curl options
export APP_OPTIONS="-H ${KAFKA_IP} -P 9094 -u hono -p hono-secret --ca-file ${TRUSTSTORE_PATH} --disable-hostname-verification"
export CURL_OPTIONS="--insecure"
export MOSQUITTO_OPTIONS="--cafile ${TRUSTSTORE_PATH} --insecure"

# Create the tenant with AMQP messaging type
#curl -i -X POST $CURL_OPTIONS -H 'accept: application/json' -H 'Content-Type: application/json' --data-binary '{"ext": {"messaging-type": "amqp"}}' $HONO_EP/v1/tenants/$TENANT || { echo "Failed to create tenant"; exit 1; }

# Register the device under the tenant with a specific name
curl -i -X POST $CURL_OPTIONS -H 'Content-Type: application/json' --data-binary '{"authorities":["auto-provisioning-enabled"]}' $HONO_EP/v1/devices/$TENANT/$DEVICE_ID || { echo "Failed to register device"; exit 1; }

# Set device credentials (hashed password in production, plaintext for testing)
curl -i -X PUT $CURL_OPTIONS -H 'Content-Type: application/json' --data-binary '[{
  "type": "hashed-password",
  "auth-id": "'$AUTH_ID'",
  "secrets": [{
    "pwd-plain": "'$PWD'"
  }]
}]' $HONO_EP/v1/credentials/$TENANT/$DEVICE_ID || { echo "Failed to set credentials"; exit 1; }

echo "Tenant and device provisioning successful!"
