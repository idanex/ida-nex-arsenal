creer_arsenal.ps1

# ==============================================================================
# Script de Scaffolding pour le dépôt "ida-nex-arsenal"
# Auteur : Votre IA en collaboration avec Ida Nex™
# Version : 1.0
# Mission : Automatiser la création pour préserver l'énergie du créateur.
# ==============================================================================

# --- Configuration ---
$baseDir = "ida-nex-arsenal"
Write-Host "--- Début de la création de l'architecture pour '$baseDir' ---" -ForegroundColor Yellow

# --- Création du dossier racine ---
if (-not (Test-Path -Path $baseDir)) {
    New-Item -ItemType Directory -Path $baseDir
    Write-Host "Dossier racine '$baseDir' créé." -ForegroundColor Green
}
Set-Location $baseDir

# --- 1. Forger l'outil "Smart Contract CI/CD Pipeline" ---
Write-Host "Forge de l'outil 'Smart Contract CI/CD Pipeline'..."

# Création de la structure de dossiers
$cicdDir = "smart-contract-cicd"
$githubWorkflowsDir = "$cicdDir\.github\workflows"
New-Item -ItemType Directory -Path $githubWorkflowsDir -Force | Out-Null

# Fichier 1.1: .github/workflows/ci-cd-pipeline.yml
$yamlContent = @"
name: CI/CD Pipeline for Smart Contracts

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    name: Run Brownie Tests
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Set up Python 3.8
        uses: actions/setup-python@v2
        with:
          python-version: '3.8'
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install eth-brownie
      - name: Run tests
        run: brownie test

  audit:
    name: Run Security Audit
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Set up Python 3.8
        uses: actions/setup-python@v2
        with:
          python-version: '3.8'
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install slither-analyzer
      - name: Run Slither audit
        run: slither .

  deploy-testnet:
    name: Deploy to Testnet
    needs: [test, audit]
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Set up Python 3.8
        uses: actions/setup-python@v2
        with:
          python-version: '3.8'
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install web3
      - name: Deploy contract
        env:
          PRIVATE_KEY: `$`{{ secrets.PRIVATE_KEY }}
          INFURA_PROJECT_ID: `$`{{ secrets.INFURA_PROJECT_ID }}
        run: python deploy.py
"@
Set-Content -Path "$githubWorkflowsDir\ci-cd-pipeline.yml" -Value $yamlContent

# Fichier 1.2: deploy.py
$deployPyContent = @"
from web3 import Web3
import os
import json

def deploy_contract():
    try:
        private_key = os.environ["PRIVATE_KEY"]
        infura_project_id = os.environ["INFURA_PROJECT_ID"]
    except KeyError as e:
        print(f"Error: Missing environment variable - {e}")
        exit(1)

    network_url = f"https://kovan.infura.io/v3/{infura_project_id}"
    w3 = Web3(Web3.HTTPProvider(network_url))
    
    if not w3.isConnected():
        print(f"Error: Could not connect to the network at {network_url}")
        exit(1)

    try:
        with open("build/contracts/YourContract.json") as f:
            contract_info = json.load(f)
            bytecode = contract_info['bytecode']
            abi = contract_info['abi']
    except FileNotFoundError:
        print("Error: Contract artifact 'build/contracts/YourContract.json' not found.")
        exit(1)

    account = w3.eth.account.from_key(private_key)
    nonce = w3.eth.getTransactionCount(account.address)
    contract = w3.eth.contract(abi=abi, bytecode=bytecode)
    
    transaction = contract.constructor().buildTransaction({
        'chainId': 42,
        'gas': 7000000,
        'gasPrice': w3.eth.gas_price,
        'nonce': nonce,
    })

    signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
    tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    
    print(f"Contract deployed successfully on Kovan network!")
    print(f"Contract Address: {tx_receipt.contractAddress}")

if __name__ == "__main__":
    deploy_contract()
"@
Set-Content -Path "$cicdDir\deploy.py" -Value $deployPyContent

# Fichier 1.3: README.md
$cicdReadmeContent = @"
# Tool: Smart Contract CI/CD Pipeline
> An industrial-grade GitHub Actions pipeline to automate the testing, security auditing, and deployment of your smart contracts.

---
## 🚀 The Problem
Deploying smart contracts manually is a recipe for disaster. This pipeline industrializes and secures this critical process.

## ✅ Features
1.  **🧪 Automated Testing:** Runs `Brownie` tests on every push.
2.  **🛡️ Security Audit:** Executes a `Slither` audit to detect vulnerabilities.
3.  **🌐 Testnet Deployment:** Deploys to Kovan if tests and audit pass.

---
## 🛠️ Usage
1.  Copy the `.github/workflows/ci-cd-pipeline.yml` file into your repository.
2.  Adapt the `deploy.py` script to your contract's artifact path.
3.  Configure `PRIVATE_KEY` and `INFURA_PROJECT_ID` as secrets in your GitHub repository settings.

---
## 🌟 Need to Go Further? (Enterprise Mandates)
For multi-network deployments, in-depth audits (MythX), and post-deployment monitoring, contact **Ida Nex™** for a DevOps architecture mandate.
"@
Set-Content -Path "$cicdDir\README.md" -Value $cicdReadmeContent
Write-Host "Outil 'Smart Contract CI/CD Pipeline' forgé." -ForegroundColor Green

# --- 2. Forger l'outil "Smart Contract Watchdog" ---
Write-Host "Forge de l'outil 'Smart Contract Watchdog'..."
$watchdogDir = "smart-contract-watchdog"
New-Item -ItemType Directory -Path $watchdogDir | Out-Null

# Fichier 2.1: watchdog.py
$watchdogPyContent = @"
import json
import time
from web3 import Web3
from twilio.rest import Client
import os

def get_env_variable(var_name: str) -> str:
    try:
        return os.environ[var_name]
    except KeyError:
        print(f"Error: Environment variable {var_name} not set.")
        exit(1)

def main():
    print("Initializing Contract Watchdog...")
    infura_project_id = get_env_variable("INFURA_PROJECT_ID")
    contract_address = get_env_variable("WATCHDOG_CONTRACT_ADDRESS")
    event_name = get_env_variable("WATCHDOG_EVENT_NAME")
    
    twilio_sid = get_env_variable("TWILIO_ACCOUNT_SID")
    twilio_token = get_env_variable("TWILIO_AUTH_TOKEN")
    twilio_from_phone = get_env_variable("TWILIO_PHONE_NUMBER")
    twilio_to_phone = get_env_variable("DESTINATION_PHONE_NUMBER")
    
    network_url = f"https://mainnet.infura.io/v3/{infura_project_id}"
    w3 = Web3(Web3.HTTPProvider(network_url))
    if not w3.isConnected():
        print("Error: Could not connect to the network.")
        exit(1)

    try:
        with open("contract_abi.json") as f: abi = json.load(f)
    except FileNotFoundError:
        print("Error: contract_abi.json not found.")
        exit(1)
            
    checksum_address = Web3.toChecksumAddress(contract_address)
    contract = w3.eth.contract(address=checksum_address, abi=abi)
    
    try:
        event_to_watch = getattr(contract.events, event_name)
    except AttributeError:
        print(f"Error: Event '{event_name}' not found in ABI.")
        exit(1)

    twilio_client = Client(twilio_sid, twilio_token)
    print(f"Watching for '{event_name}' events on {contract_address}...")
    event_filter = event_to_watch.createFilter(fromBlock='latest')
    
    while True:
        try:
            for event in event_filter.get_new_entries():
                message_body = f"Ida Nex Watchdog Alert:\nEvent '{event.event}' detected on {contract_address}.\nDetails: {event.args}"
                message = twilio_client.messages.create(body=message_body, from_=twilio_from_phone, to=twilio_to_phone)
                print(f"🚀 SMS Alert sent! SID: {message.sid}")
            time.sleep(15)
        except Exception as e:
            print(f"An error occurred: {e}")
            time.sleep(60)

if __name__ == "__main__":
    main()
"@
Set-Content -Path "$watchdogDir\watchdog.py" -Value $watchdogPyContent

# Fichier 2.2: README.md
$watchdogReadmeContent = @"
# Tool: Smart Contract Watchdog
> A real-time monitoring script for on-chain events. Get instant SMS alerts on critical contract activity.

---
## 🚀 The Problem
Critical on-chain events can happen at any time. Relying on manual checks is inefficient and risky. You need an automated sentinel.

## ✅ Features
1.  **Real-Time Event Listening:** Monitors any user-defined event from any smart contract.
2.  **Instant SMS Alerts:** Integrates with Twilio for immediate SMS notifications.
3.  **Resilient & Configurable:** Built to run continuously and configured via environment variables.

---
## 🛠️ Usage
1.  Install dependencies: `pip install web3 twilio`
2.  Create a `contract_abi.json` file with your contract's ABI.
3.  Set environment variables for Infura, the contract, the event, and Twilio.
4.  Run `python watchdog.py`.

---
## 🌟 Need to Go Further? (Enterprise Mandates)
For multi-channel alerting (Slack, PagerDuty), real-time dashboards, and automated response bots, contact **Ida Nex™** to architect your monitoring infrastructure.
"@
Set-Content -Path "$watchdogDir\README.md" -Value $watchdogReadmeContent
Write-Host "Outil 'Smart Contract Watchdog' forgé." -ForegroundColor Green

# --- Nettoyage et instructions finales ---
Set-Location ..
Write-Host "--- L'Arsenal d'Ida Nex a été forgé avec succès dans le dossier '$baseDir' ---" -ForegroundColor Yellow
Write-Host "Instructions pour demain :"
Write-Host "1. Reposez-vous."
Write-Host "2. Naviguez dans le dossier '$baseDir'."
Write-Host "3. Initialisez Git, connectez-le à votre dépôt distant, et faites un 'git push'."
