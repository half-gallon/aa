// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IThresholdStore} from "../interfaces/IThresholdStore.sol";

contract ThresholdStore is IThresholdStore {
    mapping(address => mapping(address => uint256)) private _thresholds;

    function threshold(address _token) public view returns (uint256) {
        return _thresholds[msg.sender][_token];
    }

    function threshold(address _account, address _token) public view returns (uint256) {
        return _thresholds[_account][_token];
    }

    function setThreshold(address _token, uint256 _amount) public {
        _thresholds[msg.sender][_token] = _amount;
    }
}
