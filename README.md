# 🚀 Crossing the Cosmic Void: Delay-Tolerant Networking (DTN) for Interplanetary Communication

> **Authors:** Group 12 (Computer Network)  
> **Topic:** Interplanetary Overlay Network (ION) Simulation  
> **Video Demo:** [Watch on YouTube](https://www.youtube.com/watch?v=6c-N3882Wuc)

---

## 🌌 1. The Problem: Why the "Internet" Fails in Space

In the vast expanse between Earth and Mars, communication isn't just a matter of signal strength—it's a battle against the fundamental laws of physics. Traditional network protocols (like TCP/IP), which power our modern internet, are fundamentally ill-equipped for the "Cosmic Void."

### 🛑 The "Chatty" Protocol Problem
Traditional TCP relies on a **continuous, end-to-end path** and a constant exchange of "handshakes" and acknowledgments (ACKs). 

1.  **Extreme Latency:** A signal can take between 3 to 22 minutes to travel from Earth to Mars. A simple TCP 3-way handshake could take over an hour before a single byte of data is sent.
2.  **Intermittent Connectivity:** Planetary rotation, orbital mechanics, and solar interference mean that nodes are frequently "out of sight." 
3.  **High Error Rates:** Deep space radiation causes significant packet corruption.

**Logical Deduction:** In an environment where the Round Trip Time (RTT) exceeds the protocol's timeout threshold, TCP enters a perpetual congestion control loop, effectively dropping throughput to zero. **The internet doesn't just get slow; it breaks.**

---

## 🛠️ 2. The Solution: Store-and-Forward (DTN)

To bridge this gap, we implemented a **Delay-Tolerant Network (DTN)** using NASA's **ION (Interplanetary Overlay Network)** framework.

### 📦 Bundle Protocol (BP) - The "Interplanetary Post Office"
Instead of small packets, we use **Bundles**. 
*   **Store-and-Forward:** Unlike TCP, which drops data if the next hop isn't ready, each DTN node (Earth, Relay, Mars) stores the bundle in local persistent storage until the next "contact" window opens.
*   **Custody Transfer:** Responsibility for delivery is handed off from node to node. Once the Relay receives the data, Earth is "free"—the Relay now has custody and ensures it reaches Mars.

### 🏗️ Our Simulation Architecture
We simulated a 3-node hop to demonstrate a realistic relay scenario:
**[Earth (Node 1)]** ➔ **[Relay (Node 3 - Raspberry Pi)]** ➔ **[Mars (Node 2)]**

---

## 📊 3. Performance & Trade-offs

### 📈 Logical Performance Deduction: TCP vs. Bundle Protocol
Based on our simulation and DTN theoretical models, we observed the following throughput behavior as latency increases:

| Latency (RTT) | TCP Throughput | Bundle Protocol (BP) Throughput | Observation |
| :--- | :--- | :--- | :--- |
| **10ms (Local)** | 950 Mbps | 900 Mbps | TCP wins slightly due to lower overhead. |
| **1s (Satellite)** | 50 Mbps | 850 Mbps | TCP throughput collapses due to ACK delay. |
| **20min (Mars)** | **0 Mbps (Fail)** | **800 Mbps (Success)** | **BP is the only viable option.** |

### ⚖️ Technical Trade-offs
*   **Reliability vs. Overhead:** BP introduces headers and "Custody Signals" that add overhead, but this is a necessary cost for reliability in disconnected environments.
*   **Storage vs. Connection:** DTN requires nodes to have significant storage capacity (Buffers) to hold data during long "dark" periods.
*   **Complexity:** Configuring ION is notoriously difficult. Our project solves this through **Abstraction**.

---

## 💻 4. Technical Implementation

Our project encapsulates complex ION configurations into a user-friendly, containerized environment.

*   **Dockerization:** Every node (Earth, Mars) runs in a dedicated Docker container with `NET_ADMIN` privileges, allowing for precise network manipulation and isolation.
*   **Flask Web UI:** We removed the "black box" feel of DTN. Users can upload files via a web interface on Earth and monitor their arrival on the Mars dashboard.
*   **Automated Routing:** Custom shell scripts (`set_ips.sh`) dynamically configure IP tables and ION neighbor lists, making setup plug-and-play.

---

## 🎬 5. Video Demonstration

[![Interplanetary Communication Demo](https://img.youtube.com/vi/6c-N3882Wuc/0.jpg)](https://www.youtube.com/watch?v=6c-N3882Wuc)

*Click the image above to watch the full system in action (YouTube).*

---

## 📚 6. References & Citations

1.  **Burleigh, S., et al.** (2003). "Delay-Tolerant Networking: An Approach to Interplanetary Internet." *IEEE Communications Magazine*.
2.  **NASA ION Documentation.** "Interplanetary Overlay Network (ION) - Open Source Bundle Protocol Implementation."
3.  **Cerf, V., et al.** (2007). "RFC 5050: Bundle Protocol Specification." *IETF*.

---
*Created for the 2026 Computer Network Course - Group 12.*
