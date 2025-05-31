// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MeritsStub
 * @dev A stub contract for managing user merit points
 *
 * @title MeritsStub
 * @dev Стаб-контракт для управления очками заслуг пользователей
 */
contract MeritsStub is Ownable {
    /**
     * @dev Mapping of user addresses to their merit points
     * @dev Маппинг адресов пользователей к их очкам заслуг
     */
    mapping(address => uint256) public merits;

    /**
     * @dev Emitted when merit points are awarded to a user
     * @param user Address of the user receiving merits
     * @param points Amount of merit points awarded
     * @param totalMerits Total merit points after awarding
     *
     * @dev Событие при начислении очков заслуг пользователю
     * @param user Адрес пользователя, получающего очки
     * @param points Количество начисленных очков заслуг
     * @param totalMerits Общее количество очков после начисления
     */
    event MeritsAwarded(
        address indexed user,
        uint256 points,
        uint256 totalMerits
    );

    /**
     * @dev Awards merit points to a user, only callable by owner
     * @param user Address of the user to award points to
     * @param points Amount of merit points to award
     *
     * @dev Начисляет очки заслуг пользователю, может вызывать только владелец
     * @param user Адрес пользователя для начисления очков
     * @param points Количество очков заслуг для начисления
     */
    function awardMerits(address user, uint256 points) external onlyOwner {
        merits[user] += points;
        emit MeritsAwarded(user, points, merits[user]);
    }
} 