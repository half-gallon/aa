// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "aa/core/EntryPoint.sol";

import "../contracts/account/KaraokeAccount.sol";
import "../contracts/account/KaraokeAccountFactory.sol";
import "../contracts/account/ThresholdStore.sol";
import "../contracts/verify/MockVerifier.sol";

contract TestKaraokeAccount is Test {
    address owner;
    address user;

    IEntryPoint entrypoint;
    ThresholdStore thresholdStore;
    IVerifier verifier;
    KaraokeAccount stdAcc;
    KaraokeAccountFactory factory;

    function setUp() public {
        owner = address(0x1);
        user = address(0x2);

        entrypoint = new EntryPoint();
        thresholdStore = new ThresholdStore();
        verifier = new MockVerifier();
        factory = new KaraokeAccountFactory(IEntryPoint(owner), thresholdStore);
        stdAcc = factory.createAccount(user, 0);
    }

    function test_acc() public {}
}
