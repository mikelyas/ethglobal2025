// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PythOracleStub
 * @dev A stub contract simulating Pyth oracle price feed
 *
 * @title PythOracleStub
 * @dev Стаб-контракт, симулирующий оракул цен Pyth
 */
contract PythOracleStub is Ownable {
    /**
     * @dev Default price is set to $3000 with 18 decimals
     * @dev Цена по умолчанию установлена на $3000 с 18 десятичными знаками
     */
    uint256 public price = 3000 * 1e18;

    /**
     * @dev Emitted when the price is updated
     * @param newPrice The new price value
     *
     * @dev Событие при обновлении цены
     * @param newPrice Новое значение цены
     */
    event PriceUpdated(uint256 newPrice);

    /**
     * @dev Returns the current price
     * @return Current price with 18 decimals
     */
    function getPrice() external view returns (uint256) {
        return price;
    }

    /**
     * @dev Updates the price, only callable by owner
     * @param newPrice New price value with 18 decimals
     *
     * @dev Обновляет цену, может вызывать только владелец
     * @param newPrice Новое значение цены с 18 десятичными знаками
     */
    function updatePrice(uint256 newPrice) external onlyOwner {
        price = newPrice;
        emit PriceUpdated(newPrice);
    }
} 