const hre = require("hardhat");

async function main() {
  // Get the Points smart contract
  const dgtContractFactory = await hre.ethers.getContractFactory("DegenToken");
  let initialSupply = 1000000;
  // Deploy it
  const dgt = await dgtContractFactory.deploy(initialSupply);
  await dgt.waitForDeployment();

  // Display the contract address
  console.log(`Points token deployed to ${dgt.target}`);

  if (hre.network.config.chainId === 43113) {
    await dgt.deploymentTransaction().wait(6);
    await verify(dgt.target, [initialSupply]);
  }
}

async function verify(contractAddress, args) {
  try {
    await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (error) {
    if (error.message.toLowerCase().includes("already verified")) {
      console.log("Contract already verified");
    } else {
      console.log("Error verifying contract:", error);
    }
  }
}

// Hardhat recommends this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
