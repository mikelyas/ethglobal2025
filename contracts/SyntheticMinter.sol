// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SyntheticMinter is ERC20, Ownable {
    // Collateral ratio (150%) - percentage of ETH needed to mint tokens
    // Коэффициент обеспечения (150%) - процент ETH, необходимый для чеканки токенов
    uint256 public collateralRatio = 150;

    // Events for tracking collateral deposits and redemptions
    // События для отслеживания внесения и погашения обеспечения
    event CollateralDeposited(address indexed user, uint256 amountDeposited, uint256 amountMinted);
    event CollateralRedeemed(address indexed user, uint256 amountBurned, uint256 ETHReturned);

    constructor() ERC20("Synthetic Token", "SYNTH") Ownable(msg.sender) {}

    /**
     * @dev Deposits ETH and mints synthetic tokens based on collateral ratio
     * @notice User deposits ETH and receives synthetic tokens at the current collateral ratio
     * 
     * Внесение ETH и чеканка синтетических токенов на основе коэффициента обеспечения
     * Пользователь вносит ETH и получает синтетические токены по текущему коэффициенту обеспечения
     */
    function depositAndMint() external payable {
        // Check that deposit amount is greater than zero
        // Проверка, что сумма депозита больше нуля
        require(msg.value > 0, "Cannot deposit zero");

        // Calculate amount of tokens to mint based on collateral ratio
        // Расчет количества токенов для чеканки на основе коэффициента обеспечения
        uint256 mintAmount = (msg.value * 100) / collateralRatio;

        // Mint tokens to the sender
        // Чеканка токенов отправителю
        _mint(msg.sender, mintAmount);

        // Emit deposit event
        // Выпуск события о внесении обеспечения
        emit CollateralDeposited(msg.sender, msg.value, mintAmount);
    }

    /**
     * @dev Burns synthetic tokens and returns the corresponding ETH collateral
     * @param burnAmount Amount of synthetic tokens to burn
     * @notice User burns synthetic tokens and receives ETH back at the current collateral ratio
     * 
     * Сжигание синтетических токенов и возврат соответствующего обеспечения в ETH
     * Пользователь сжигает синтетические токены и получает обратно ETH по текущему коэффициенту обеспечения
     */
    function burnAndRedeem(uint256 burnAmount) external {
        // Check that user has enough tokens to burn
        // Проверка, что у пользователя достаточно токенов для сжигания
        require(balanceOf(msg.sender) >= burnAmount, "Insufficient synth balance");

        // Calculate ETH amount to return based on collateral ratio
        // Расчет количества ETH для возврата на основе коэффициента обеспечения
        uint256 redeemAmount = (burnAmount * collateralRatio) / 100;

        // Burn the synthetic tokens
        // Сжигание синтетических токенов
        _burn(msg.sender, burnAmount);

        // Send ETH back to the user
        // Отправка ETH обратно пользователю
        (bool success, ) = payable(msg.sender).call{value: redeemAmount}("");
        require(success, "ETH transfer failed");

        // Emit redeem event
        // Выпуск события о погашении обеспечения
        emit CollateralRedeemed(msg.sender, burnAmount, redeemAmount);
    }
} 