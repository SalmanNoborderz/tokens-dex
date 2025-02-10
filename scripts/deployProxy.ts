const { ethers, upgrades } = require("hardhat");

async function main() {
    // Retrieve the deployer's address
    const [deployer] = await ethers.getSigners();

    const factoryAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    const WETHAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    const initialOwner = deployer.address;
    console.log({initialOwner});

    const ContractFactory = await ethers.getContractFactory("TokenDEX");

    // Deploy proxy with the initializer argument set to the deployer's address
    const contract = await upgrades.deployProxy(
        ContractFactory,
        [factoryAddress, WETHAddress, initialOwner], // Pass the deployer's address and additional parameter(s)
        { initializer: 'initialize' }
    );

    await contract.waitForDeployment();
    const proxyAddress = await contract.getAddress();
    console.log({ proxyAddress });

    // Get the implementation address
    const implementationAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);
    console.log({ implementationAddress });

    // Verify the contract
    await hre.run("verify:verify", {
        address: proxyAddress,
        constructorArguments: [initialOwner],
    });
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
