const { ethers, upgrades } = require("hardhat");

async function main() {
    const name = "TRC20Token";
    const symbol = "TRC20";
    const totalSupply = 5000000000;

    const TokenContractFactory = await ethers.getContractFactory("TRC20Token");
    const TokenContract = await TokenContractFactory.deploy(name, symbol, totalSupply);
    await TokenContract.waitForDeployment();
    const TokenContractAddress = await TokenContract.getAddress();

    console.log(`Router Contract deployed to ${TokenContractAddress}`);

    // await hre.run("verify:verify", {
    //   address: factoryContractAddress,
    //   constructorArguments: [],
    // });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
