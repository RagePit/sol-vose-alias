// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";
import {SSTORE2} from "solmate/utils/SSTORE2.sol";

import {AliasPacked} from "./AliasPacked.sol";

contract AliasPackedTest is DSTest {

    uint constant WEIGHT_LEN = 1000;
    uint constant TEST_RUNS = 1000;

    uint[] weights;
    uint weightSum;
    address pointer;
    function setUp() public {
        
        uint[] memory _weights = new uint[](WEIGHT_LEN);
        uint sum;

        // uint[10] memory __weights = [uint(150), 100, 201, 611, 500, 205, 300, 300, 101, 559];

        for(uint i = 0; i < WEIGHT_LEN; i++) {
            uint r = uint(keccak256(abi.encode(i))) % 100000;
            // uint r = 100;
            // uint r = __weights[i];
            _weights[i] = r;
            sum += r;
        }

        weightSum = sum;
        weights = _weights;
        
        pointer = AliasPacked.init(_weights);
    } 

    function testEncode() public {
        uint24 encoded = AliasPacked.encode(4095, 800);
        assertEq(encoded, 8387360);
    }

    function testDecode() public {
        (uint16 p, uint16 a) = AliasPacked.decode(8387360);
        assertEq(p, 4095);
        assertEq(a, 800);
    }

    function testSingleValue() public {
        uint precision = AliasPacked.precision();
        address _pointer = pointer;

        uint r = uint(keccak256(abi.encode(200)));
        uint column = r % WEIGHT_LEN;
        
        (uint16 p, uint16 a) = AliasPacked.pluck(_pointer, column);
        
        bool side = r % precision < p;
        uint ret = side ? column : a;
    }

    function testAliasPackedPrecision() public {
        uint[] memory found = new uint[](WEIGHT_LEN);
        
        uint precision = AliasPacked.precision();
        address _pointer = pointer;

        for (uint i = 0; i < TEST_RUNS; i++) {
            uint r = uint(keccak256(abi.encode(i, 2)));
            uint column = r % WEIGHT_LEN;
            
            (uint16 p, uint16 a) = AliasPacked.pluck(_pointer, column);
            
            bool side = r % precision < p;
            uint ret = side ? column : a;
            found[ret]++;
        }
        emit log("~~~~~~~~ PACKED ~~~~~~~");

        // uint[] memory _weights = weights;
        // uint sum = weightSum;

        for (uint i = 0; i < WEIGHT_LEN; i++) {
            // uint f = found[i] * 100000 / TEST_RUNS;
            // uint weight = _weights[i];
            // uint expected = weight * 100000 / sum;
            (uint16 pr, ) = AliasPacked.pluck(_pointer, i);
            uint p = pr;

            emit log_named_decimal_uint("Prob", p*100000/precision, 3);
            // emit log(string(
            //     abi.encodePacked(
            //         "Prob    ",
            //         uint2str(p),
            //         "  ",
            //         u
            //     )
            // ));
            // emit log_named_uint("Alias", a);
            // emit log(string(
            //     abi.encodePacked(
            //         "Expected    ",
            //         uint2str(weight*TEST_RUNS/sum)
            //         // uint2str(expected/1000),
            //         // ".",
            //         // uint2str(expected%1000),
            //         // "%"
            //     )
            // ));
            // emit log(string(
            //     abi.encodePacked(
            //         "Actual      ",
            //         uint2str(found[i])
            //         // uint2str(f/1000),
            //         // ".",
            //         // uint2str(f%1000),
            //         // "%\n"
            //     )
            // ));

            // assertLt(uint(abs(int(f) - int(expected))), 1000);
        }

        // assert(false);
    }

    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    function uint2str(
        uint256 _i
    )
    internal
    pure
    returns (string memory str)
    {
        if (_i == 0)
        {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0)
        {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0)
        {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }
    
}
