// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./stubs/PythOracleStub.sol";
import "./stubs/CrossChainMock.sol";
import "./stubs/SwapManagerStub.sol";
import "./stubs/EmailRecoveryStub.sol";
import "./stubs/MeritsStub.sol";
import "./stubs/FlowSyntheticStub.sol";

contract SyntheticMinter is Ownable {
    PythOracleStub public pythOracle;
    CrossChainMock public crossChainMock;
    SwapManagerStub public swapManager;
    EmailRecoveryStub public emailRecovery;
    MeritsStub public merits;
    FlowSyntheticStub public flowSynthetic;

    event CollateralDeposited(address indexed user, uint256 amountDeposited, uint256 amountMinted);
    event CollateralRedeemed(address indexed user, uint256 amountBurned, uint256 amountETHReturned);

    constructor(
        address _pythOracle,
        address _crossChainMock,
        address _swapManager,
        address _emailRecovery,
        address _merits,
        address _flowSynthetic
    ) Ownable(msg.sender) {
        pythOracle = PythOracleStub(_pythOracle);
        crossChainMock = CrossChainMock(_crossChainMock);
        swapManager = SwapManagerStub(_swapManager);
        emailRecovery = EmailRecoveryStub(_emailRecovery);
        merits = MeritsStub(_merits);
        flowSynthetic = FlowSyntheticStub(_flowSynthetic);
    }

    function depositAndMint() external payable returns (uint256) {
        require(msg.value > 0, "Must deposit ETH");
        
        // Calculate mint amount (150% collateralization ratio)
        uint256 mintAmount = (msg.value * 100) / 150;
        
        // Mint synthetic tokens
        flowSynthetic.receiveCrossChainSynth(msg.sender, mintAmount);
        
        emit CollateralDeposited(msg.sender, msg.value, mintAmount);
        return mintAmount;
    }

    function burnAndRedeem(uint256 amount) external returns (uint256) {
        require(amount > 0, "Must burn non-zero amount");
        
        // Calculate ETH to return (150% collateralization ratio)
        uint256 ethToReturn = (amount * 150) / 100;
        require(address(this).balance >= ethToReturn, "Insufficient ETH in contract");
        
        // Burn synthetic tokens
        flowSynthetic.burnToEthereum(msg.sender, amount);
        
        // Return ETH
        (bool success, ) = payable(msg.sender).call{value: ethToReturn}("");
        require(success, "ETH transfer failed");
        
        emit CollateralRedeemed(msg.sender, amount, ethToReturn);
        return ethToReturn;
    }

    // Function to receive ETH
    receive() external payable {}
} 