// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {SimpleAccount} from "aa/samples/SimpleAccount.sol";
import {IEntryPoint} from "aa/interfaces/IEntryPoint.sol";
import {UserOperation} from "aa/interfaces/UserOperation.sol";

import {ByteSlicer} from "../libs/ByteSlicer.sol";
import {IKaraokeAccount} from "../interfaces/IKaraokeAccount.sol";
import {IThresholdStore} from "../interfaces/IThresholdStore.sol";
import {IVerifier} from "../interfaces/Verifier.sol";

contract KaraokeAccount is SimpleAccount, IKaraokeAccount {
    using ECDSA for bytes32;

    uint256 internal constant VOICE_VALIDATION_FAILED = 2;

    address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IVerifier private verifier;
    IThresholdStore private thresholdStore;
    ByteSlicer private slicer = new ByteSlicer();

    constructor(IEntryPoint _entrypoint, IThresholdStore _thresholdStore) SimpleAccount(_entrypoint) {
        thresholdStore = _thresholdStore;
    }

    function initialize(address _owner) public virtual override initializer {
        super._initialize(_owner);
        verifier = IVerifier(address(0));
    }

    function bytesToUint(bytes memory b) internal pure returns (uint256) {
        uint256 number;
        for (uint256 i = 0; i < b.length; i++) {
            number = number + uint256(uint8(b[i])) * (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }

    function _verifyVoiceProof(bytes calldata _signature) internal view returns (bool) {
        // get public input count
        uint8 inputCount = uint8(_signature[65]);
        // get public inputs
        uint256[] memory pubInputs = new uint256[](inputCount);
        for (uint8 i = 0; i < inputCount; i++) {
            bytes memory pubInputRaw = _signature[66 + (i * 32):66 + (i * 32 + 32)];
            pubInputs[i] = bytesToUint(pubInputRaw);
        }
        // get proof
        bytes memory proof = _signature[66 + (inputCount * 32):];

        return verifier.verify(pubInputs, proof);
    }

    function _extractTxValue(bytes calldata callData) internal view returns (address, uint256) {
        if (bytes4(callData[0:4]) == SimpleAccount.execute.selector) {
            // decode dest, value, func
            (address dest, uint256 value, bytes memory func) = abi.decode(callData[4:], (address, uint256, bytes));

            if (value > 0) {
                return (ETH_ADDRESS, value);
            }

            // FIXME: hack
            if (bytes4(slicer.slice(func, 0, 4)) == IERC20.transfer.selector) {
                // decode to, amount
                (, uint256 amount) = abi.decode(slicer.slice(func, 4), (address, uint256));
                return (dest, amount);
            }
        }

        return (address(0), 0);
    }

    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
        internal
        view
        override
        returns (uint256 validationData)
    {
        // verify owner signature
        bytes32 hash = userOpHash.toEthSignedMessageHash();
        if (owner != hash.recover(userOp.signature[0:65])) {
            return SIG_VALIDATION_FAILED;
        }

        // verify voice proof
        (address asset, uint256 amount) = _extractTxValue(userOp.callData);
        if (amount > thresholdStore.threshold(asset)) {
            if (!_verifyVoiceProof(userOp.signature)) {
                return VOICE_VALIDATION_FAILED;
            }
        }

        return 0;
    }

    function getVerifier() external view override returns (IVerifier) {
        return verifier;
    }

    function setVerifier(IVerifier _newVerifier) external override onlyOwner {
        verifier = _newVerifier;
    }
}
