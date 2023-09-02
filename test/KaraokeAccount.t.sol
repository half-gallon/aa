// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/account/KaraokeAccount.sol";
import "../src/account/KaraokeAccountFactory.sol";
import "../src/account/ThresholdStore.sol";

contract TestKaraokeAccount is Test {
    address owner;
    address user;

    ThresholdStore thresholdStore;
    KaraokeAccount stdAcc;
    KaraokeAccountFactory factory;

    function setUp() public {
        owner = address(0x1);
        user = address(0x2);

        thresholdStore = new ThresholdStore();
        factory = new KaraokeAccountFactory(IEntryPoint(owner), thresholdStore);
        stdAcc = factory.createAccount(user, 0);
    }

    function test_acc() public {
        console.log("acc", address(stdAcc));
        console.log("owner", stdAcc.owner());
    }
}
