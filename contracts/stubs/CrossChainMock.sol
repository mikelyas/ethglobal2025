// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CrossChainMock
 * @dev Mock contract for simulating cross-chain transfers (only events, no real logic)
 * Мок-контракт для симуляции межсетевых переводов (только события, без реальной логики)
 */
contract CrossChainMock {
    // Events for cross-chain transfer simulation
    // События для симуляции межсетевых переводов
    event CrossChainSent(address indexed user, uint256 amount);
    event CrossChainReceived(address indexed user, uint256 amount);

    /**
     * @dev Simulates sending tokens to Ethereum
     * @param user Address of the user sending tokens
     * @param amount Amount of tokens to send
     * 
     * Симулирует отправку токенов в сеть Ethereum
     * @param user Адрес пользователя, отправляющего токены
     * @param amount Количество отправляемых токенов
     */
    function sendToEthereum(address user, uint256 amount) external {
        emit CrossChainSent(user, amount);
    }

    /**
     * @dev Simulates receiving tokens from Ethereum
     * @param user Address of the user receiving tokens
     * @param amount Amount of tokens to receive
     * 
     * Симулирует получение токенов из сети Ethereum
     * @param user Адрес пользователя, получающего токены
     * @param amount Количество получаемых токенов
     */
    function receiveFromEthereum(address user, uint256 amount) external {
        emit CrossChainReceived(user, amount);
    }
} 