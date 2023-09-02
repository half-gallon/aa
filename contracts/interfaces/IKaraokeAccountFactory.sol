// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../account/KaraokeAccount.sol";

interface IKaraokeAccountFactory {
    function createAccount(address owner, uint256 salt) external returns (KaraokeAccount ret);

    function getAddress(address owner, uint256 salt) external view returns (address);
}
