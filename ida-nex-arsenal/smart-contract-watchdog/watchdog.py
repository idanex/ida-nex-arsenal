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
