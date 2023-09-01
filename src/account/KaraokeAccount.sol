// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IEntryPoint} from "aa/interfaces/IEntryPoint.sol";
import {UserOperation} from "aa/interfaces/UserOperation.sol";

import {SimpleAccount} from "./SimpleAccount.sol";
import {IKaraokeAccount} from "../interfaces/IKaraokeAccount.sol";
import {IVerifier} from "../interfaces/Verifier.sol";

contract KaraokeAccount is SimpleAccount, IKaraokeAccount {
    IVerifier private verifier;
    uint256 private verificationThreshold;
    uint256 public constant DEFAULT_VERIFICATION_THRESHOLD = 10 ether;

    constructor(IEntryPoint _entrypoint) SimpleAccount(_entrypoint) {}

    function initialize(address _owner, IVerifier _verifier) public virtual initializer {
        super._initialize(_owner);
        verifier = _verifier;
        verificationThreshold = DEFAULT_VERIFICATION_THRESHOLD;
    }

    function bytesToUint(bytes memory b) internal pure returns (uint256) {
        uint256 number;
        for (uint256 i = 0; i < b.length; i++) {
            number = number + uint256(uint8(b[i])) * (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }

    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
        internal
        override
        returns (uint256 validationData)
    {
        // verify owner signature
        super._validateSignature(userOp, userOpHash);

        // verify voice proof
        bytes4 selector = bytes4(userOp.callData[0:4]);
        if (selector == SimpleAccount.execute.selector) {
            bytes memory callData = userOp.callData[4:];
            (, uint256 callValue,) = abi.decode(callData, (address, uint256, bytes));

            if (callValue >= verificationThreshold) {
                // get public input count
                uint8 inputCount = uint8(userOp.signature[65]);
                // get public inputs
                uint256[] memory pubInputs = new uint256[](inputCount);
                for (uint8 i = 0; i < inputCount; i++) {
                    bytes memory pubInputRaw = userOp.signature[66 + (i * 32):66 + (i * 32 + 32)];
                    pubInputs[i] = bytesToUint(pubInputRaw);
                }
                // get proof
                bytes memory proof = userOp.signature[66 + (inputCount * 32):];

                bool ok = verifier.verify(pubInputs, proof);

                if (!ok) {
                    return SIG_VALIDATION_FAILED;
                }
            }
        }

        return 0;
    }

    function setOwner(address _newOwner) external override onlyOwner {
        owner = _newOwner;
    }

    function getVerifier() external view override returns (IVerifier) {
        return verifier;
    }

    function setVerifier(IVerifier _newVerifier) external override onlyOwner {
        verifier = _newVerifier;
    }

    function getVerificationThreshold() external view override returns (uint256) {
        return verificationThreshold;
    }

    function setVerificationThreshold(uint256 _amount) external override onlyOwner {
        verificationThreshold = _amount;
    }
}
