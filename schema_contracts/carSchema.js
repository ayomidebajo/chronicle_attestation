const { SchemaRegistry } = require("@ethereum-attestation-service/eas-sdk");
const { ethers } = require('ethers');

async function registerSchema() {
    const schemaRegistryContractAddress = "0xYourSchemaRegistryContractAddress";
    const schemaRegistry = new SchemaRegistry(schemaRegistryContractAddress);

    // Assuming `signer` is already defined and is an instance of ethers.Signer
    schemaRegistry.connect(signer);

    const schema = "uint256 carId, , uint8 ownerScore";
    const resolverAddress = "0x0a7E2Ff54e76B8E6659aedc9103FB21c038050D0"; // Sepolia 0.26
    const revocable = true;

    try {
        const transaction = await schemaRegistry.register({
            schema,
            resolverAddress,
            revocable,
        });

        // Optional: Wait for transaction to be validated
        await transaction.wait();
        console.log('Schema registered successfully');
    } catch (error) {
        console.error('Error registering schema:', error);
    }
}

registerSchema();
