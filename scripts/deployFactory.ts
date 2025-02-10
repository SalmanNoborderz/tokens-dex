const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const FactoryContractFactory = await ethers.getContractFactory("TokenDexFactory");
  const factoryContract = await FactoryContractFactory.deploy(deployer);
  await factoryContract.waitForDeployment();
  const factoryContractAddress = await factoryContract.getAddress();
  console.log(`Contract deployed to ${factoryContractAddress}`);

  const pairHash = await factoryContract.getPairHash();
  console.log(`Pair hash: ${pairHash}`);

  await hre.run("verify:verify", {
    address: factoryContractAddress,
    constructorArguments: [],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
