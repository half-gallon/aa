// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

import "aa/core/EntryPoint.sol";

import "../contracts/account/KaraokeAccount.sol";
import "../contracts/account/KaraokeAccountFactory.sol";
import "../contracts/account/ThresholdStore.sol";
import "../contracts/verify/MockVerifier.sol";

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

struct Account {
    address addr;
    uint256 key;
}

contract Deployer is Script {
    using DeploymentsLib for Deployments;

    Account internal owner;
    Account internal user;

    address[] internal initAddrs = [
        0x9D152d8d65ec27F7b77d27073F86abd7a4A42871,
        0xF386C6E1bA02E1b827EC12990717C4Dc2af4F31a,
        0x1F5aC320417F6d3b1cB76a51220B2530fdFD6125,
        0x9f4f81832A8D552B51001D5cD97F195573deDE26,
        0xdcA2fF91E57d1703d62d09f8f83dD5F985fc1Dc5
    ];

    function fetchAccount(string memory addr, string memory key) internal view returns (Account memory) {
        return Account({addr: vm.envAddress(addr), key: uint256(vm.envBytes32(key))});
    }

    function setUp() public {
        owner = fetchAccount("ADDR_OWNER", "KEY_OWNER");
        user = fetchAccount("ADDR_USER", "KEY_USER");
    }

    function fuel(Deployments memory deployments, address[] memory _addrs, uint256 _key) internal {
        vm.startBroadcast(_key);

        uint256 amount = 10000 ether;

        for (uint256 i = 0; i < _addrs.length; i++) {
            {
                deployments.yaho.mint(_addrs[i], amount);
            }

            {
                (bool sent,) = payable(_addrs[i]).call{value: amount}("");
                require(sent, "Failed to send Ether");
            }
        }

        vm.stopBroadcast();
    }

    function deploy(address _user, uint256 _key) internal returns (Deployments memory deployments) {
        vm.startBroadcast(_key);

        ERC20PresetMinterPauser yaho = new ERC20PresetMinterPauser("MooYaaHo", "YAHO");
        EntryPoint entrypoint = new EntryPoint();
        ThresholdStore thresholdStore = new ThresholdStore();
        MockVerifier verifier = new MockVerifier();
        KaraokeAccountFactory factory = new KaraokeAccountFactory(entrypoint, thresholdStore);
        KaraokeAccount stdAcc = factory.createAccount(_user, 0);

        deployments = Deployments({
            yaho: yaho,
            entrypoint: entrypoint,
            thresholdStore: thresholdStore,
            verifier: verifier,
            stdAcc: stdAcc,
            factory: factory
        });

        vm.stopBroadcast();
    }

    function run() public {
        Deployments memory deployments = deploy(user.addr, owner.key);
        deployments.exportJson(vm);

        fuel(deployments, initAddrs, owner.key);
    }
}
