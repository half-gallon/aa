// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IAccount} from "aa/interfaces/IAccount.sol";

import {IVerifier} from "./Verifier.sol";

interface IKaraokeAccount is IAccount {
    function getVerifier() external view returns (IVerifier);

    function setVerifier(IVerifier _newVerifier) external;
}
