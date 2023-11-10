require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: process.env.ALCHEMY_API_KEY,
      accounts: [process.env.POLYGON_MUMBAI_PRIVATE_KEY]
    },
  }
};
