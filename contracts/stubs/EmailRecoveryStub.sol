// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title EmailRecoveryStub
 * @dev A stub contract simulating email-based account recovery
 *
 * @title EmailRecoveryStub
 * @dev Стаб-контракт, симулирующий восстановление аккаунта через email
 */
contract EmailRecoveryStub {
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
     * @return true Always returns true in this stub
     */
    function recoverAccess(
        bytes calldata proof,
        bytes32 emailHash
    ) external returns (bool) {
        // Stub: always return true
        emit EmailRecovered(msg.sender, emailHash);
        return true;
    }
} 