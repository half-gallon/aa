// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IVerifier} from "../interfaces/Verifier.sol";

contract MockVerifier is IVerifier {
    function verify(uint256[] memory pubInputs, bytes memory) public pure returns (bool) {
        return pubInputs.length % 2 == 1;
    }
}
