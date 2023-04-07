#!/bin/bash
RECORD_TYPE="A"

# Get the zone ID for the domain
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${SECRET_PUBLIC_DOMAIN}" \
-H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
-H "X-Auth-Key: ${CLOUDFLARE_APIKEY}" \
-H "Content-Type: application/json" | jq -r '.result[0].id')

# Get the current IP address
IP=$(curl -s https://ipv4.icanhazip.com/)

# Check if the DNS record exists
EXISTING_RECORD=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=$RECORD_TYPE&name=${CLOUDFLARE_RECORD_NAME}" \
-H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
-H "X-Auth-Key: ${CLOUDFLARE_APIKEY}" \
-H "Content-Type: application/json")

# If the record does not exist, create it with the current IP address
if [[ $(echo "$EXISTING_RECORD" | jq '.result | length') -eq 0 ]]; then
  echo "Creating DNS record..."
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
  -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
  -H "X-Auth-Key: ${CLOUDFLARE_APIKEY}" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"$RECORD_TYPE\",\"name\":\"${CLOUDFLARE_RECORD_NAME}\",\"content\":\"$IP\",\"ttl\":120}"
else
  # Update the existing record with the new IP address
  RECORD_ID=$(echo "$EXISTING_RECORD" | jq -r '.result[0].id')
  echo "Updating DNS record $RECORD_ID with IP address $IP..."
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
  -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
  -H "X-Auth-Key: ${CLOUDFLARE_APIKEY}" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"$RECORD_TYPE\",\"name\":\"${CLOUDFLARE_RECORD_NAME}\",\"content\":\"$IP\",\"ttl\":120}"
fi
