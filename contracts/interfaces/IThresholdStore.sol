// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IThresholdStore {
    function threshold(address _token) external view returns (uint256);

    function threshold(address _account, address _token) external view returns (uint256);

    function setThreshold(address _token, uint256 _amount) external;
}
