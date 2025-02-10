require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@typechain/hardhat");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");

module.exports = {
  solidity: {
    version: "0.7.6",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
    }
  },
  etherscan: { // mainnet
    // apiKey: "95GRQ4VCKSZMQMJSS6H514M7CR6Z8RRVG9"
    apiKey: {
      xanamainnet: "xanamainnet", // apiKey is not required, just set a placeholder
      bsc: "95GRQ4VCKSZMQMJSS6H514M7CR6Z8RRVG9"
    },
    customChains: [
      {
        network: "xanamainnet",
        chainId: 8888,
        urls: {
          apiURL: "https://api.routescan.io/v2/network/mainnet/evm/8888/etherscan",
          browserURL: "https://8888.routescan.io"
        }
      },
      {
        network: "bsc",
        chainId: 56,
        urls: {
          apiURL: "https://api.bscscan.com/api",
          browserURL: "https://bscscan.com",
        },
      }
    ]
  },
  // etherscan: { // testnet
  //   apiKey: {
  //     snowtrace: "snowtrace", // apiKey is not required, just set a placeholder
  //   },
  //   customChains: [
  //     {
  //       network: "snowtrace",
  //       chainId: 43113,
  //       urls: {
  //         apiURL: "https://api.routescan.io/v2/network/testnet/evm/43113/etherscan",
  //         browserURL: "https://testnet.snowtrace.io"
  //       }
  //     }
  //   ]
  // },
  networks: {
    // snowtrace: { // testnet
    //   url: 'https://api.avax-test.network/ext/bc/C/rpc',
    //   accounts: ['f4dd4ae26d58142f59addf6b5e4308e5f38871b230279d130396afc33e5a8973']
    // },
    // snowtrace: { // mainnet
    //   url: 'https://api.avax.network/ext/bc/C/rpc',
    //   accounts: ['1a0f33bcf93e9907b3deed6e734706b36b142ee8d2c159217d852607b22a9091']
    // },
    // bsctestnet: {
    //   url: 'https://bsc-testnet.blockpi.network/v1/rpc/664bde42ededdc11785fafa648a80ff024ef1c88',
    //   accounts: ['f4dd4ae26d58142f59addf6b5e4308e5f38871b230279d130396afc33e5a8973']
    // }
    // bscmainnet: {
    //   url: 'https://bsc.blockpi.network/v1/rpc/c6278c4ecdde3e89917dc93bab815efe99f3874a',
    //   accounts: ['63312e2eefee74dde63149b1615bee4973de3199993eacd2b04a3430db8f81f0']
    // },
    xanatestnet: {
      url: 'https://testnet.xana.net/rpc',
      accounts: ['f4dd4ae26d58142f59addf6b5e4308e5f38871b230279d130396afc33e5a8973']
    },
    xanamainnet: {
      url: 'https://mainnet.xana.net/rpc',
      accounts: ['a50a410b5f6408fa3f2c4272d9edb74238e557e21cc4eb93467d7e8c1873512c']
    },
    // ethmainnet: {
    //   url: 'https://mainnet.infura.io/v3/02a5c5ee88a54c59acc1bfad1338ca2c',
    //   accounts: ['6b385e642a1587c2d5d6f2ba25bd7cdf529ccc91dea9067708e268a6c2cd66bb']
    // },
    // bsc: {
    //   url: "https://bsc-mainnet.infura.io/v3/02a5c5ee88a54c59acc1bfad1338ca2c",
    //   accounts: ["9224eadb9b1c79b89c7032da63866271894b6043c7569843ce6fecb4adacba60"],
    //   gas: 12000000,   // Increase the gas limit
    //   gasPrice: 20000000000,  // Adjust the gas price
    //   // gasLimit: 5000000,
    //   chainId: 56,
    // }
    wow: {
      url: "https://rpc.wowearn.io",
      accounts: ["9224eadb9b1c79b89c7032da63866271894b6043c7569843ce6fecb4adacba60"],
      gas: 12000000,   // Increase the gas limit
      // gasPrice: 20000000000,  // Adjust the gas price
      // gasLimit: 5000000,
      chainId: 1916,
    }
  }
};
