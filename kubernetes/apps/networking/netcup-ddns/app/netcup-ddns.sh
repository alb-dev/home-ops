#!/bin/bash

# Get the current IPv4 address
IPV4=$(curl -s https://ipv4.icanhazip.com/)

# Get the domain ID for the domain
DOMAIN_ID=$(curl -s -X POST "https://ccp.netcup.net/run/webservice/servers/any/*/domain?webspace=active" \
-H "Content-Type: text/xml;charset=UTF-8" \
-H "Accept: text/xml" \
-d "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\"><soap:Body><domain_get_by_name xmlns=\"http://webservices.domainapi.com/\">$DOMAIN</domain_get_by_name></soap:Body></soap:Envelope>" \
| sed -n 's/.*<id>\([^<]*\)<\/id>.*/\1/p')

# Check if the A record exists
EXISTING_RECORD=$(curl -s -X POST "https://ccp.netcup.net/run/webservice/servers/any/webspace/record?webspace=active" \
-H "Content-Type: text/xml;charset=UTF-8" \
-H "Accept: text/xml" \
-d "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\"><soap:Body><domain_dns_zone_record_info xmlns=\"http://webservices.domainapi.com/\"><domain_dns_zone_record><id></id><zoneId>$DOMAIN_ID</zoneId><hostname>$RECORD_NAME</hostname><recordtype>$RECORD_TYPE</recordtype></domain_dns_zone_record></domain_dns_zone_record_info></soap:Body></soap:Envelope>" \
| sed -n 's/.*<id>\([^<]*\)<\/id>.*/\1/p')

# If the A record does not exist, create it with the current IPv4 address
if [[ $(echo "$EXISTING_RECORD" | grep -c "was not found on the server") -eq 1 ]]; then
  echo "Creating A record..."
  curl -s -X POST "https://ccp.netcup.net/run/webservice/servers/any/webspace/record?webspace=active" \
  -H "Content-Type: text/xml;charset=UTF-8" \
  -H "Accept: text/xml" \
  -d "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\"><soap:Body><domain_dns_zone_record_add xmlns=\"http://webservices.domainapi.com/\"><domain_dns_zone_record><zoneId>$DOMAIN_ID</zoneId><hostname>$RECORD_NAME</hostname><recordtype>$RECORD_TYPE</recordtype><recorddata>$IPV4</recorddata><ttl>120</ttl></domain_dns_zone_record></domain_dns_zone_record_add></soap:Body></soap:Envelope>"
else
  # Update the existing A record with the new IPv4 address
  RECORD_ID=$(echo "$EXISTING_RECORD" | grep -oPm1 "(?<=<id>)[^<]+")
  echo "Updating A record $RECORD_ID with IP address $IPV4..."
  curl -s -X POST "https://
