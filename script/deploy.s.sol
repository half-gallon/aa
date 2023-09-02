// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

import "aa/core/EntryPoint.sol";

import "../src/account/KaraokeAccount.sol";
import "../src/account/KaraokeAccountFactory.sol";
import "../src/account/ThresholdStore.sol";
import "../src/verify/MockVerifier.sol";

struct Deployments {
    ERC20PresetMinterPauser yaho;
    IEntryPoint entrypoint;
    ThresholdStore thresholdStore;
    IVerifier verifier;
    KaraokeAccount stdAcc;
    KaraokeAccountFactory factory;
}

library DeploymentsLib {
    function exportJson(Deployments memory v, VmSafe vm) internal {
        string memory builder = "deployments";
        vm.serializeAddress(builder, "yaho", address(v.yaho));
        vm.serializeAddress(builder, "entrypoint", address(v.entrypoint));
        vm.serializeAddress(builder, "thresholdStore", address(v.thresholdStore));
        vm.serializeAddress(builder, "verifier", address(v.verifier));
        vm.serializeAddress(builder, "stdAcc", address(v.stdAcc));
        builder = vm.serializeAddress(builder, "factory", address(v.factory));
        vm.writeJson(builder, "./output/deployments.json");
    }
}

contract Deployer is Script {
    using DeploymentsLib for Deployments;

    function setUp() public view {}

    function run() public {
        address owner = vm.envAddress("ADDR_OWNER");
        address user = vm.envAddress("ADDR_USER");

        uint256 deployerKey = uint256(vm.envBytes32("KEY_DEPLOYER"));
        uint256 userKey = uint256(vm.envBytes32("KEY_USER"));

        vm.startBroadcast(deployerKey);

        ERC20PresetMinterPauser yaho = new ERC20PresetMinterPauser("MooYaaHo", "YAHO");
        EntryPoint entrypoint = new EntryPoint();
        ThresholdStore thresholdStore = new ThresholdStore();
        MockVerifier verifier = new MockVerifier();
        KaraokeAccountFactory factory = new KaraokeAccountFactory(entrypoint, thresholdStore);
        KaraokeAccount stdAcc = factory.createAccount(user, 0);

        Deployments memory deployments = Deployments({
            yaho: yaho,
            entrypoint: entrypoint,
            thresholdStore: thresholdStore,
            verifier: verifier,
            stdAcc: stdAcc,
            factory: factory
        });

        vm.stopBroadcast();

        deployments.exportJson(vm);
    }
}
