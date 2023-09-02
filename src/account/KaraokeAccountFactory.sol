// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {IEntryPoint} from "aa/interfaces/IEntryPoint.sol";

import {KaraokeAccount} from "./KaraokeAccount.sol";
import {IThresholdStore} from "../interfaces/IThresholdStore.sol";

contract KaraokeAccountFactory {
    KaraokeAccount public immutable accountImplementation;

    constructor(IEntryPoint _entryPoint, IThresholdStore _thresholdStore) {
        accountImplementation = new KaraokeAccount(_entryPoint, _thresholdStore);
    }

    /**
     * create an account, and return its address.
     * returns the address even if the account is already deployed.
     * Note that during UserOperation execution, this method is called only if the account is not deployed.
     * This method returns an existing account address so that entryPoint.getSenderAddress() would work even after account creation
     */
    function createAccount(address owner, uint256 salt) public returns (KaraokeAccount ret) {
        address addr = getAddress(owner, salt);
        uint256 codeSize = addr.code.length;
        if (codeSize > 0) {
            return KaraokeAccount(payable(addr));
        }
        ret = KaraokeAccount(
            payable(
                new ERC1967Proxy{salt : bytes32(salt)}(
                address(accountImplementation),
                abi.encodeCall(KaraokeAccount.initialize, (owner))
                )
            )
        );
    }

    /**
     * calculate the counterfactual address of this account as it would be returned by createAccount()
     */
    function getAddress(address owner, uint256 salt) public view returns (address) {
        return Create2.computeAddress(
            bytes32(salt),
            keccak256(
                abi.encodePacked(
                    type(ERC1967Proxy).creationCode,
                    abi.encode(address(accountImplementation), abi.encodeCall(KaraokeAccount.initialize, (owner)))
                )
            )
        );
    }
}
