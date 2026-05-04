#!/bin/bash

# --- Deep Space Network Simulation Setup ---
# Relay node acts as the bridge. No extra delay/loss added here 
# unless you want to simulate link-specific noise.
INTERFACE=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
echo "Relay node starting on $INTERFACE..."

# --- Initialize ION ---
ionadmin < relay.ionrc
ltpadmin < relay.ltprc
bpadmin < relay.bprc
ipnadmin < relay.ipnrc

echo "Relay Node (Node 3) is now active and routing bundles."
tail -f /dev/null
