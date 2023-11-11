
const hre = require("hardhat");
// const { ethers } = require('ethers');
const { ethers } = require("hardhat");

const { Bytecode } = require("hardhat/internal/hardhat-network/stack-traces/model");
require('dotenv').config();


async function main() {
  const Chronicle = await ethers.getContractFactory("Chronicle");

  // Start deployment, returning a promise that resolves to a contract object
  const chronicle = await Chronicle.deploy();
  console.log("Waiting for contract to deployed...");

  // await chronicle.deployed();
  console.log(chronicle.target)








  // const url = process.env.ALCHEMY_URL;

  // let artifacts = await hre.artifacts.readArtifact("Chronicle");

  // const provider = new ethers.JsonRpcProvider(url);
  // //const signer = await provider.getSigner();

  // let privateKey = process.env.PRIVATE_KEY;

  // let wallet = new ethers.Wallet(privateKey, provider);

  // // Create an instance of a Faucet Factory
  // let chronicle = await hre.ethers.getContractFactory("Chronicle");
  // // let factory = new ethers.ContractFactory(artifacts.abi, artifacts.bytecode, wallet);

  // let Chronicle = await chronicle.deploy();
  // await Chronicle.deployed();

  // console.log("chronical address" + chronicle.address);

  // const registerCar = await chronicle.registerCar("IIKKJIILISE", "0x89523c33416c256a3c27Dc46CfD5ac939ADE2951");
  // console.log(registerCar);
  // const updateCar = await chronicle.updateCarHistory("IIKKJIILISE", 30, 2000, 10);
  // console.log(updateCar)
  // const add = await chronicle.addCarHistory("IIKKJIILISE", 40, 5000, 20);
  // console.log(add);
  const getCar = await chronicle.getCarHistory("IIKKJIILISE");
  console.log(getCar);



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
