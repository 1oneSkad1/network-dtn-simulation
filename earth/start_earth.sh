#!/bin/bash

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
        
        echo "[NETWORK] Link DOWN (Occultation)"
        tc qdisc del dev $INTERFACE root 2>/dev/null
        tc qdisc add dev $INTERFACE root netem loss 100%
        sleep $DOWN_TIME
    done
) &

# 무조건 중간 노드를 거치도록 하려면 설정
# iptables -A OUTPUT -d [화성 아이피] -j DROP

# --- Initialize ION ---
# Redirect output to ion.log for the web UI
{
    ionadmin < earth.ionrc
    ltpadmin < earth.ltprc
    bpadmin < earth.bprc
    ipnadmin < earth.ipnrc
} > ion.log 2>&1

# Start the Flask app
python3 app.py
