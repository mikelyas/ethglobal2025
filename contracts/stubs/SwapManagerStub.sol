// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SwapManagerStub
 * @dev A stub contract simulating token swaps with fixed rate
 *
 * @title SwapManagerStub
 * @dev Стаб-контракт, симулирующий обмен токенов с фиксированным курсом
 */
contract SwapManagerStub {
    /**
     * @dev Emitted when a swap is executed
     * @param user Address of the user performing the swap
     * @param amountIn Amount of input tokens
     * @param tokenOut Address of the output token
     * @param amountOut Amount of output tokens received
     *
     * @dev Событие при выполнении обмена
     * @param user Адрес пользователя, выполняющего обмен
     * @param amountIn Количество входящих токенов
     * @param tokenOut Адрес выходного токена
     * @param amountOut Количество полученных выходных токенов
     */
    event SwapExecuted(
        address indexed user,
        uint256 amountIn,
        address tokenOut,
        uint256 amountOut
    );

    /**
     * @dev Simulates a swap from synthetic token to another token with fixed 90% rate
     * @param user Address of the user performing the swap
     * @param amountIn Amount of synthetic tokens to swap
     * @param tokenOut Address of the token to receive
     * @return amountOut Amount of output tokens received
     */
    function swapSynthToToken(
        address user,
        uint256 amountIn,
        address tokenOut
    ) external returns (uint256 amountOut) {
        // For stub, set fixed rate: amountOut = (amountIn * 90) / 100
        amountOut = (amountIn * 90) / 100;
        emit SwapExecuted(user, amountIn, tokenOut, amountOut);
        return amountOut;
    }
} 