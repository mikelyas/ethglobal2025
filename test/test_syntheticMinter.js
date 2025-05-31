const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

describe("Synthetic Minting System", function () {
    let owner;
    let user;
    let syntheticMinter;
    let pythOracle;
    let crossChainMock;
    let swapManager;
    let emailRecovery;
    let merits;
    let flowSynthetic;
    
    // Constants
    const dummyToken = "0x0000000000000000000000000000000000000001";
    const dummyEmailHash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test@example.com"));
    const dummyProof = "0x";

    beforeEach(async function () {
        // Get signers
        [owner, user] = await ethers.getSigners();

        // Deploy all contracts
        const PythOracleStub = await ethers.getContractFactory("PythOracleStub");
        pythOracle = await PythOracleStub.deploy();
        await pythOracle.deployed();

        const CrossChainMock = await ethers.getContractFactory("CrossChainMock");
        crossChainMock = await CrossChainMock.deploy();
        await crossChainMock.deployed();

        const SwapManagerStub = await ethers.getContractFactory("SwapManagerStub");
        swapManager = await SwapManagerStub.deploy();
        await swapManager.deployed();

        const EmailRecoveryStub = await ethers.getContractFactory("EmailRecoveryStub");
        emailRecovery = await EmailRecoveryStub.deploy();
        await emailRecovery.deployed();

        const MeritsStub = await ethers.getContractFactory("MeritsStub");
        merits = await MeritsStub.deploy();
        await merits.deployed();

        const FlowSyntheticStub = await ethers.getContractFactory("FlowSyntheticStub");
        flowSynthetic = await FlowSyntheticStub.deploy();
        await flowSynthetic.deployed();

        const SyntheticMinter = await ethers.getContractFactory("SyntheticMinter");
        syntheticMinter = await SyntheticMinter.deploy(
            pythOracle.address,
            crossChainMock.address,
            swapManager.address,
            emailRecovery.address,
            merits.address,
            flowSynthetic.address
        );
        await syntheticMinter.deployed();
    });

    describe("Test Case 1: Deposit and Mint", function () {
        it("should correctly deposit ETH and mint synthetic tokens", async function () {
            const depositAmount = ethers.utils.parseEther("1.0");
            const expectedMintAmount = depositAmount.mul(100).div(150);

            await expect(
                syntheticMinter.connect(user).depositAndMint({ value: depositAmount })
            ).to.emit(syntheticMinter, "CollateralDeposited")
                .withArgs(user.address, depositAmount, expectedMintAmount);

            const balance = await flowSynthetic.balanceOf(user.address);
            expect(balance).to.equal(expectedMintAmount);

            const oraclePrice = await pythOracle.getPrice();
            expect(oraclePrice).to.equal(ethers.utils.parseEther("3000"));
        });
    });

    describe("Test Case 2: Burn and Redeem", function () {
        it("should correctly burn synthetic tokens and redeem ETH", async function () {
            // First mint some tokens
            const depositAmount = ethers.utils.parseEther("1.0");
            await syntheticMinter.connect(user).depositAndMint({ value: depositAmount });
            const mintAmount = depositAmount.mul(100).div(150);

            // Get initial ETH balance
            const initialBalance = await user.getBalance();

            // Burn and redeem
            await expect(
                syntheticMinter.connect(user).burnAndRedeem(mintAmount)
            ).to.emit(syntheticMinter, "CollateralRedeemed")
                .withArgs(user.address, mintAmount, mintAmount.mul(150).div(100));

            // Check ETH balance increased
            const finalBalance = await user.getBalance();
            expect(finalBalance.sub(initialBalance)).to.be.closeTo(
                depositAmount,
                ethers.utils.parseEther("0.01") // Allow for gas costs
            );
        });
    });

    describe("Test Case 3: CrossChainMock", function () {
        it("should handle cross-chain operations correctly", async function () {
            await expect(
                crossChainMock.sendToEthereum(user.address, 1000)
            ).to.emit(crossChainMock, "CrossChainSent")
                .withArgs(user.address, 1000);

            await expect(
                crossChainMock.receiveFromEthereum(user.address, 500)
            ).to.emit(crossChainMock, "CrossChainReceived")
                .withArgs(user.address, 500);
        });
    });

    describe("Test Case 4: SwapManagerStub", function () {
        it("should handle swaps correctly with fixed 90% rate", async function () {
            const amountIn = 1000;
            const expectedAmountOut = 900; // 90% of input

            const tx = await swapManager.swapSynthToToken(user.address, amountIn, dummyToken);
            const receipt = await tx.wait();
            
            // Check event emission
            await expect(
                swapManager.swapSynthToToken(user.address, amountIn, dummyToken)
            ).to.emit(swapManager, "SwapExecuted")
                .withArgs(user.address, amountIn, dummyToken, expectedAmountOut);
        });
    });

    describe("Test Case 5: EmailRecoveryStub", function () {
        it("should handle email recovery correctly", async function () {
            const tx = await emailRecovery.connect(user).recoverAccess(dummyProof, dummyEmailHash);
            const receipt = await tx.wait();

            // Check event emission
            await expect(
                emailRecovery.connect(user).recoverAccess(dummyProof, dummyEmailHash)
            ).to.emit(emailRecovery, "EmailRecovered")
                .withArgs(user.address, dummyEmailHash);
        });
    });

    describe("Test Case 6: MeritsStub", function () {
        it("should handle merit points correctly", async function () {
            await expect(
                merits.awardMerits(user.address, 15)
            ).to.emit(merits, "MeritsAwarded")
                .withArgs(user.address, 15, 15);

            const userMerits = await merits.merits(user.address);
            expect(userMerits).to.equal(15);
        });
    });
}); 