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
     * @dev Contract constructor - sets msg.sender as the initial owner
     * @dev Конструктор контракта - устанавливает msg.sender как начального владельца
     */
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Emitted when account access is recovered using email verification
     * @param user Address of the user recovering access
     * @param emailHash Hash of the email used for recovery
     *
     * @dev Событие при восстановлении доступа к аккаунту через подтверждение email
     * @param user Адрес пользователя, восстанавливающего доступ
     * @param emailHash Хеш email, использованного для восстановления
     */
    event EmailRecovered(address indexed user, bytes32 emailHash);

    /**
     * @dev Simulates account recovery using email proof (always returns true)
     * @param proof Verification proof data (unused in stub)
     * @param emailHash Hash of the email used for recovery
     * @return success Always returns true in this stub
     */
    function recoverAccess(
        bytes calldata proof,
        bytes32 emailHash
    ) external returns (bool) {
        // Stub: always return true
        emit EmailRecovered(msg.sender, emailHash);
        return true;
    }

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