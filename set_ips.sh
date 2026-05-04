#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: ./set_ips.sh <EARTH_IP> <RELAY_IP> <MARS_IP>"
    echo "Example: ./set_ips.sh 192.168.1.10 192.168.1.20 192.168.1.30"
    exit 1
fi

EARTH_IP=$1
RELAY_IP=$2
MARS_IP=$3

# Earth (Node 1) -> Relay (Node 3)
sed -i "s/udplso .*:1113/udplso $RELAY_IP:1113/g" earth/earth.ltprc

# Mars (Node 2) -> Relay (Node 3)
sed -i "s/udplso .*:1113/udplso $RELAY_IP:1113/g" mars/mars.ltprc

# Relay (Node 3) -> Earth (Node 1) & Mars (Node 2)
sed -i "s/span 1 .* udplso .*:1113/span 1 128 128 1024 1024 1 'udplso $EARTH_IP:1113'/g" relay/relay.ltprc
sed -i "s/span 2 .* udplso .*:1113/span 2 128 128 1024 1024 1 'udplso $MARS_IP:1113'/g" relay/relay.ltprc

echo "Successfully updated all IP configurations."
echo "Earth: $EARTH_IP | Relay: $RELAY_IP | Mars: $MARS_IP"
