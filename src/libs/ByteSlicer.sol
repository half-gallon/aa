// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ByteSlicer {
    function slice(bytes calldata _data, uint256 _from, uint256 _to) public pure returns (bytes memory) {
        return _data[_from:_to];
    }

    function slice(bytes calldata _data, uint256 _from) public pure returns (bytes memory) {
        return _data[_from:];
    }
}
