
<h4 align="center">Verify any car’s health and history on the Blockchain </h4>

<h4 align="center"> What if you could verify the health of a car, it’s identity and its history on the blockchain? </h4>

### Key features

- Cars connected on chain will be connected with their verified owners. 
- Owners can transfer ownership on-chain whenever they are selling a car. 
- Interested buyers can check the health and status of a car and also see previous owners if any.

### How it works

The OBD is connected to a backend server which also contains a socket server that listens for specified commands. This server is then connected to the frontend application. The frontend makes the get requests and sends the data to the smart contract without any input needed from the user. The car’s identity is created using the VIN and is connected to the owner’s address on chain.
Interested sellers can access the car’s identity and view the health and histories of a car. 

### Mode of purchasing a car using Chronicle

Blockchains don’t just handle payments, they also handle identity. Cars already have VIN(vehicle identification number). This means cars do have identities and they can also be stored on chain and have their histories tracked.  Buyers would be able to check the identity of a car on-chain and view its history

### How To Use

To clone and run this application, you'll need to follow the following command line:

```bash
# Clone this repository
$ git clone https://github.com/ayomidebajo/chronicle_attestation 

# Install dependencies
$ npm install
$ npm install --save-dev hardhat
$ npm install @nomiclabs/hardhat-waffle
$ npm install ethereum-waffle chai
$ npm install @nomiclabs/hardhat-ethers ethers
$ npm install dotenv
$ npm install hardhat

# Run the app
$ npm start
```


