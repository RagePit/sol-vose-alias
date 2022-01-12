// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";

contract AlternatesTest is DSTest {

    uint constant WEIGHT_LEN = 250;
    uint constant TEST_RUNS = 1000;

    uint[] weights;
    uint weightSum;

    function setUp() public {
        uint[] memory _weights = new uint[](WEIGHT_LEN);

        uint sum = 0;
        for(uint i = 0; i < WEIGHT_LEN; i++) {
            // uint r = uint(keccak256(abi.encode(i))) % 100000;
            uint r = 1000000 - i*100;
            _weights[i] = i == 0 ? r : _weights[i-1] + r;
            sum += r;
        }

        weightSum = sum;
        weights = _weights;
    }

    // function testSumRun() public {
    //     uint len = weights.length;
    //     uint max = weights[len - 1];

    //     for (uint j = 0; j < TEST_RUNS; j++) {
    //         uint rand = uint(keccak256(abi.encode(j))) % max;

    //         uint i = 0;
    //         //unironically cheaper to get from storage than to cast weights to memory
    //         for ( ; i < len; i++) {
    //             uint current = weights[i];
    //             if (current > rand) break;
    //         }
    //     }
    // }

    

    // i dont even think this works
    // function testBinRun() public view {
    //     uint len = weights.length;
    //     uint max = weights[len - 1];

    //     for (uint j = 0; j < TEST_RUNS; j++) {
    //         uint rand = uint(keccak256(abi.encode(j))) % max;

    //         uint low = 0;
    //         uint high = len - 1;
    //         uint value = rand % max;
    //         uint mid = 0;
            
    //         while (low <= high) {
    //             mid = low + ((high - low) / 2);
    //             uint cur = weights[mid];
    //             if ((mid == 0 && cur > value) || (weights[mid-1] < value && cur > value))
    //                 break;
    //             if (cur > value)
    //                 high = mid - 1;
    //             else if (cur < value)
    //                 low = mid + 1;
    //             else
    //                 break;
    //         }
    //     }
    // }


}
