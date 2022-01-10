// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";

import {AliasPacked} from "./AliasPacked.sol";

contract AliasInitTest is DSTest {

    uint constant WEIGHT_LEN = 1000;

    uint[] weights;
    uint weightSum;

    function setUp() public {
        
        uint[] memory _weights = new uint[](WEIGHT_LEN);

        uint sum = 0;
        for(uint i = 0; i < WEIGHT_LEN; i++) {
            uint r = uint(keccak256(abi.encode(i))) % 10000;
            _weights[i] = r;
            sum += r;
        }

        weightSum = sum;
        weights = _weights;

    }

    address pointer;

    function testAliasPackedInit() public {
        pointer = AliasPacked.init(weights);
    }

}
