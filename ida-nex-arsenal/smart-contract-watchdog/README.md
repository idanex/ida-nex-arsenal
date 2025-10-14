# Tool: Smart Contract Watchdog
> A real-time monitoring script for on-chain events. Get instant SMS alerts on critical contract activity.

---
## ?? The Problem
Critical on-chain events can happen at any time. Relying on manual checks is inefficient and risky. You need an automated sentinel.

## ? Features
1.  **Real-Time Event Listening:** Monitors any user-defined event from any smart contract.
2.  **Instant SMS Alerts:** Integrates with Twilio for immediate SMS notifications.
3.  **Resilient & Configurable:** Built to run continuously and configured via environment variables.

---
## ??? Usage
1.  Install dependencies: pip install web3 twilio
2.  Create a contract_abi.json file with your contract's ABI.
3.  Set environment variables for Infura, the contract, the event, and Twilio.
4.  Run python watchdog.py.

---
## ?? Need to Go Further? (Enterprise Mandates)
For multi-channel alerting (Slack, PagerDuty), real-time dashboards, and automated response bots, contact **Ida Nex™** to architect your monitoring infrastructure.
