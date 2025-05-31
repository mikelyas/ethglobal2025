const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  // Deploy PythOracleStub
  const PythOracleStub = await ethers.getContractFactory("PythOracleStub");
  const pythOracle = await PythOracleStub.deploy();
  await pythOracle.deployed();
  console.log("PythOracleStub deployed to:", pythOracle.address);

  // Deploy CrossChainMock
  const CrossChainMock = await ethers.getContractFactory("CrossChainMock");
  const crossChainMock = await CrossChainMock.deploy();
  await crossChainMock.deployed();
  console.log("CrossChainMock deployed to:", crossChainMock.address);

  // Deploy FlowSyntheticStub
  const FlowSyntheticStub = await ethers.getContractFactory("FlowSyntheticStub");
  const flowSynthetic = await FlowSyntheticStub.deploy();
  await flowSynthetic.deployed();
  console.log("FlowSyntheticStub deployed to:", flowSynthetic.address);

  // Deploy SwapManagerStub
  const SwapManagerStub = await ethers.getContractFactory("SwapManagerStub");
  const swapManager = await SwapManagerStub.deploy();
  await swapManager.deployed();
  console.log("SwapManagerStub deployed to:", swapManager.address);

  // Deploy EmailRecoveryStub
  const EmailRecoveryStub = await ethers.getContractFactory("EmailRecoveryStub");
  const emailRecovery = await EmailRecoveryStub.deploy();
  await emailRecovery.deployed();
  console.log("EmailRecoveryStub deployed to:", emailRecovery.address);

  // Deploy MeritsStub
  const MeritsStub = await ethers.getContractFactory("MeritsStub");
  const merits = await MeritsStub.deploy();
  await merits.deployed();
  console.log("MeritsStub deployed to:", merits.address);

  // Deploy SyntheticMinter with all dependencies
  const SyntheticMinter = await ethers.getContractFactory("SyntheticMinter");
  const syntheticMinter = await SyntheticMinter.deploy(
    pythOracle.address,
    crossChainMock.address,
    swapManager.address,
    emailRecovery.address,
    merits.address,
    flowSynthetic.address
  );
  await syntheticMinter.deployed();
  console.log("SyntheticMinter deployed to:", syntheticMinter.address);

  // Prepare addresses object
  const addresses = {
    PythOracleStub: pythOracle.address,
    CrossChainMock: crossChainMock.address,
    FlowSyntheticStub: flowSynthetic.address,
    SwapManagerStub: swapManager.address,
    EmailRecoveryStub: emailRecovery.address,
    MeritsStub: merits.address,
    SyntheticMinter: syntheticMinter.address
  };

  // Write addresses to file
  fs.writeFileSync(
    'deployedAddresses.json',
    JSON.stringify(addresses, null, 2)
  );
  console.log("Addresses written to deployedAddresses.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 