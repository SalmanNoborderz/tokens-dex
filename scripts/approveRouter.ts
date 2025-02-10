const { ethers } = require("hardhat");

async function main() {
    const tokenAddress = "0x5317B2BE7a812d7718A342CfE63c93BB3c2d8D29"; // Replace with your token address
    const routerAddress = "0x62B377b84029ef07accE6f7257839d6C994F9424"; // Replace with your router address
    const approvalAmount = "10000000000000000000000000";

    // Get the token contract factory
    const TokenContractFactory = await ethers.getContractFactory("TRC20Token");
    
    // Deploy new token (remove if using already deployed token)
    const TokenContract = await TokenContractFactory.attach(tokenAddress); // Replace with your token address

    
    // Call the approve method on the token contract.
    const tx = await TokenContract.approve(routerAddress, approvalAmount);
    await tx.wait();
    console.log(`Approved ${approvalAmount} tokens for router ${routerAddress}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
