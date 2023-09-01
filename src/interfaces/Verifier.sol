// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVerifier {
    function verify(uint256[] memory pubInputs, bytes memory proof) external view returns (bool);
}
