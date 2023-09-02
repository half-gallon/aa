// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "aa/core/EntryPoint.sol";

import "../src/account/KaraokeAccount.sol";
import "../src/account/KaraokeAccountFactory.sol";
import "../src/account/ThresholdStore.sol";
import "../src/verify/MockVerifier.sol";

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
