// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";

import {Alias} from "./Alias.sol";
import {AliasPacked} from "./AliasPacked.sol";

contract AliasRunTest is DSTest {

    uint constant WEIGHT_LEN = 10;
    uint constant TEST_RUNS = 1000;

    Alias aliasMethod;
    AliasPacked aliasPackedMethod;

    uint[] weights;
    uint weightSum;

    function setUp() public {
        
        uint[] memory _weights = new uint[](WEIGHT_LEN);
        uint sum;

        uint[10] memory __weights = [uint(10), 10, 10, 100, 100, 100, 1000, 1000, 1000, 5000];

        for(uint i = 0; i < WEIGHT_LEN; i++) {
            // uint r = uint(keccak256(abi.encode(i))) % 10000;
            // uint r = 100;
            uint r = __weights[i];
            _weights[i] = r;
            sum += r;
        }

        weightSum = sum;
        weights = _weights;

        aliasMethod = new Alias();
        aliasPackedMethod = new AliasPacked();
        
        aliasMethod.init(_weights);
        aliasPackedMethod.init(_weights);
    }

    // function testAliasRun() public {
    //     uint precision = aliasMethod.precision();
    //     for (uint i = 0; i < TEST_RUNS; i++) {
    //         uint r = uint(keccak256(abi.encode(i)));

    //         uint column = r % WEIGHT_LEN;
    //         bool side = r % precision < aliasMethod.prob(column);

    //         uint ret = side ? column : aliasMethod.aliases(column);
    //     }
        
    // }

    // function testAliasPackedRun() public {
    //     uint precision = aliasPackedMethod.precision();
    //     for (uint i = 0; i < TEST_RUNS; i++) {
    //         uint r = uint(keccak256(abi.encode(i)));

    //         uint column = r % WEIGHT_LEN;
    //         (uint16 p, uint16 a) = aliasPackedMethod.decode(aliasPackedMethod.aliases(column));
    //         bool side = r % precision < p;

    //         uint ret = side ? column : a;
    //     }
    // }

    function testAliasPrecision() public {
        uint[] memory found = new uint[](WEIGHT_LEN);
        
        uint precision = aliasMethod.precision();
        uint16[] memory prob = aliasMethod.probabilities();
        uint16[] memory al = aliasMethod.getAliases();

        for (uint i = 0; i < TEST_RUNS; i++) {
            // uint g = gasleft();
            uint r = uint(keccak256(abi.encode(i, 10)));
            uint column = r % WEIGHT_LEN;
            bool side = r % precision < prob[column];

            uint ret = side ? column : al[column];
            found[ret]++;
        }

        emit log("~~~~~~~~");

        uint[] memory _weights = weights;
        uint sum = weightSum;

        for (uint i = 0; i < WEIGHT_LEN; i++) {

            uint f = found[i] * 10000 / TEST_RUNS;
            uint weight = _weights[i];
            uint expected = weight * 10000 / sum;
            emit log_named_uint("Prob", prob[i]);
            emit log_named_uint("Alias", al[i]);
            emit log(string(
                abi.encodePacked(
                    "Expected    ",
                    uint2str(expected/100),
                    ".",
                    uint2str(expected%100),
                    "%"
                )
            ));
            emit log(string(
                abi.encodePacked(
                    "Actual      ",
                    uint2str(f/100),
                    ".",
                    uint2str(f%100),
                    "%\n"
                )
            ));
            // emit log_named_uint("Expected", expected);

            // int e = int(expected) - int(f);
            // if (e < 0) e *= -1;

            // uint ep = uint(e) * 100 * 100 / expected;
            // emit log(string(
            //     abi.encodePacked(
            //         uint2str(ep/100),
            //         ".",
            //         uint2str(ep%100),
            //         "%"
            //     )
            // ));
        }

        assert(false);
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
