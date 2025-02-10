const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    const tokenA = "0x9c40DfC76Db67625A849DC01a8f4625Ca8842325"; // Replace with your token address
    const tokenB = "0x5317B2BE7a812d7718A342CfE63c93BB3c2d8D29"; // Replace with your token address
    const amountADesired = "100000000000000000000";
    const amountBDesired = "100000000000000000000";

    const routerAddress = "0x62B377b84029ef07accE6f7257839d6C994F9424"; // Replace with your router address

    // Get the token contract factory
    const RouterContractFactory = await ethers.getContractFactory("TokenDEXRouter");
    
    // Deploy new token (remove if using already deployed token)
    const RouterContract = await RouterContractFactory.attach(routerAddress); // Replace with your token address
    
    // Call the approve method on the token contract.
    const tx = await RouterContract.addLiquidity(
        tokenA,
        tokenB,
        amountADesired,
        amountBDesired,
        1,
        1,
        deployer.address,
        1896976719
    );
    await tx.wait();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
