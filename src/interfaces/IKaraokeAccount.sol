// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IAccount} from "aa/interfaces/IAccount.sol";

import {IVerifier} from "./Verifier.sol";

interface IKaraokeAccount is IAccount {
    function setOwner(address _newOwner) external;

    function getVerifier() external view returns (IVerifier);

    function setVerifier(IVerifier _newVerifier) external;

    function getVerificationThreshold() external view returns (uint256);

    function setVerificationThreshold(uint256 _amount) external;
}
