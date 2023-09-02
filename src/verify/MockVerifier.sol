// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IVerifier} from "../interfaces/Verifier.sol";

contract MockVerifier is IVerifier {
    function verify(bytes memory) public view returns (bool) {
        return block.number % 2 == 1;
    }
}
