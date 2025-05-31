// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FlowSyntheticStub is ERC20 {
    // Events for cross-chain synthetic token operations
    // События для операций с синтетическими токенами между сетями
    event FlowSynthReceived(address indexed user, uint256 amount);
    event FlowSynthBurned(address indexed user, uint256 amount);

    constructor() ERC20("Flow Synthetic Token", "FLOW") {}

    /**
     * @dev Receives synthetic tokens from another chain and mints them to the user
     * @param user Address of the token recipient
     * @param amount Amount of tokens to mint
     *
     * @dev Получает синтетические токены из другой сети и минтит их пользователю
     * @param user Адрес получателя токенов
     * @param amount Количество токенов для минта
     */
    function receiveCrossChainSynth(address user, uint256 amount) external {
        _mint(user, amount);
        emit FlowSynthReceived(user, amount);
    }

    /**
     * @dev Burns synthetic tokens to be bridged back to Ethereum
     * @param user Address of the token holder
     * @param amount Amount of tokens to burn
     *
     * @dev Сжигает синтетические токены для возврата в сеть Ethereum
     * @param user Адрес держателя токенов
     * @param amount Количество токенов для сжигания
     */
    function burnToEthereum(address user, uint256 amount) external {
        _burn(user, amount);
        emit FlowSynthBurned(user, amount);
    }
} 