#!/bin/bash

# --- Physical Layer Simulation: WiFi Power Limitation ---
# Attempt to find WiFi interface and set TX power to 1dBm (very weak)


# --- Deep Space Network Simulation Setup ---
INTERFACE=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
DELAY="10000ms"  # 10 seconds one-way
LOSS="5%"
RATE="1mbit"
UP_TIME=60
DOWN_TIME=20

echo "Configuring network for Deep Space conditions on $INTERFACE..."
echo "Delay: $DELAY, Loss: $LOSS, Rate: $RATE"

# Background loop for Intermittent Connectivity
(
    while true; do
        echo "[NETWORK] Link UP"
        tc qdisc del dev $INTERFACE root 2>/dev/null
        tc qdisc add dev $INTERFACE root netem delay $DELAY loss $LOSS rate $RATE
        sleep $UP_TIME
        
        echo "[NETWORK] Link DOWN (Antenna repositioning)"
        tc qdisc del dev $INTERFACE root 2>/dev/null
        tc qdisc add dev $INTERFACE root netem loss 100%
        sleep $DOWN_TIME
    done
) &

# --- Initialize ION ---
ionadmin < mars.ionrc
ltpadmin < mars.ltprc
bpadmin < mars.bprc
ipnadmin < mars.ipnrc

# Start bprecvfile to listen on ipn:2.1 and save to 'received' directory
mkdir -p received
cd received
bprecvfile ipn:2.1 &
cd ..

# Start the Flask app
python3 app.py
