const { ethers, upgrades } = require("hardhat");

async function main() {
  const factoryContractAddress = "0x8ca10aF691D2DdF44e4bce780edd70def6c8Ad81";
  const WETHAddress = "0x8ca10aF691D2DdF44e4bce780edd70def6c8Ad81";

  const RotuerContractFactory = await ethers.getContractFactory("TokenDEXRouter");
  const RouterContract = await RotuerContractFactory.deploy(factoryContractAddress, WETHAddress);
  await RouterContract.waitForDeployment();
  const RouterContractAddress = await RouterContract.getAddress();

  console.log(`Router Contract deployed to ${RouterContractAddress}`);

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
