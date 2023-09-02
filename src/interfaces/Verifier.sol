// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVerifier {
    function verify(uint256[] calldata pubInputs, bytes calldata proof) external view returns (bool);
}
