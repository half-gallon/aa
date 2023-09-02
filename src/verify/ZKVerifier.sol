// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Verifier} from "model/Verifier.sol";

import {IVerifier} from "../interfaces/Verifier.sol";

/**
 * $$\    $$\ $$$$$$$$\ $$$$$$$\  $$$$$$\ $$$$$$$$\ $$$$$$\ $$$$$$$$\ $$$$$$$\
 * $$ |   $$ |$$  _____|$$  __$$\ \_$$  _|$$  _____|\_$$  _|$$  _____|$$  __$$\
 * $$ |   $$ |$$ |      $$ |  $$ |  $$ |  $$ |        $$ |  $$ |      $$ |  $$ |
 * \$$\  $$  |$$$$$\    $$$$$$$  |  $$ |  $$$$$\      $$ |  $$$$$\    $$$$$$$  |
 *  \$$\$$  / $$  __|   $$  __$$<   $$ |  $$  __|     $$ |  $$  __|   $$  __$$<
 *   \$$$  /  $$ |      $$ |  $$ |  $$ |  $$ |        $$ |  $$ |      $$ |  $$ |
 *    \$  /   $$$$$$$$\ $$ |  $$ |$$$$$$\ $$ |      $$$$$$\ $$$$$$$$\ $$ |  $$ |
 *     \_/    \________|\__|  \__|\______|\__|      \______|\________|\__|  \__|
 */

contract ZKVerifier is IVerifier, Verifier {
    function verify(bytes calldata proof) public view returns (bool) {
        return this.verify(
            [
                uint256(1), // [0] is true if it's owner's voice
                uint256(0) // [1] is true if it's other's voice
            ],
            proof
        );
    }
}
