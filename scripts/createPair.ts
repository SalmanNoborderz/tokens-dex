const { ethers } = require("hardhat");

async function main() {
    // Replace with your deployed factory address or use an env variable
    const factoryAddress = process.env.FACTORY_ADDRESS || "0x8ca10aF691D2DdF44e4bce780edd70def6c8Ad81";

    // Attach to the existing factory
    const FactoryContractFactory = await ethers.getContractFactory("TokenDexFactory");
    const factoryContract = FactoryContractFactory.attach(factoryAddress);

    // Call the createPair method
    const tx = await factoryContract.createPair("0x9c40DfC76Db67625A849DC01a8f4625Ca8842325", "0x5317B2BE7a812d7718A342CfE63c93BB3c2d8D29");
    console.log(`Transaction submitted: ${tx.hash}`);
    await tx.wait();
    console.log("Pair created");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
