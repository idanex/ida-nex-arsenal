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
