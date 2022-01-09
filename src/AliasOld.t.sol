// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.6;

// import {DSTest} from "ds-test/test.sol";

// import {AliasOld} from "./AliasOld.sol";

// contract AliasRunTest is DSTest {

//     uint constant WEIGHT_LEN = 10;
//     uint constant TEST_RUNS = 10000;

//     AliasOld aliasOld;

//     uint[] weights;
//     uint weightSum;

//     function setUp() public {
        
//         uint[] memory _weights = new uint[](WEIGHT_LEN);
//         uint sum;

//         uint[10] memory __weights = [uint(150), 100, 201, 611, 500, 205, 300, 300, 101, 559];

//         for(uint i = 0; i < WEIGHT_LEN; i++) {
//             // uint r = uint(keccak256(abi.encode(i))) % 1000000;
//             // uint r = 100;
//             uint r = __weights[i];
//             _weights[i] = r;
//             sum += r;
//         }

//         weightSum = sum;
//         weights = _weights;

//         aliasOld = new AliasOld();
        
//         aliasOld.init(_weights, 0);
//     } 

//     function testAliasOldPrecision() public {
//         uint[] memory found = new uint[](WEIGHT_LEN);
        
//         uint precision = aliasOld.precision();
//         uint16[] memory prob = aliasOld.probabilities(0);
//         uint16[] memory al = aliasOld.getAliases(0);

//         for (uint i = 0; i < TEST_RUNS; i++) {
//             uint r = uint(keccak256(abi.encode(i, 2)));
//             uint column = r % WEIGHT_LEN;
//             bool side = r % precision < prob[column];

//             uint ret = side ? column : al[column];
//             found[ret]++;
//         }

//         emit log("~~~~~~~~ OLD ~~~~~~~");

//         uint[] memory _weights = weights;
//         uint sum = weightSum;

//         for (uint i = 0; i < WEIGHT_LEN; i++) {

//             uint f = found[i] * 100000 / TEST_RUNS;
//             uint weight = _weights[i];
//             uint expected = weight * 100000 / sum;
//             uint p = prob[i];

//             emit log(string(
//                 abi.encodePacked(
//                     "Prob    ",
//                     // uint2str(p)
//                     uint2str(p*100/precision),
//                     ".",
//                     uint2str(p*100%precision),
//                     "%"
//                 )
//             ));
//             // emit log_named_uint("Alias", al[i]);
//             // emit log(string(
//             //     abi.encodePacked(
//             //         "Expected    ",
//             //         uint2str(weight*TEST_RUNS/sum)
//             //         // uint2str(expected/1000),
//             //         // ".",
//             //         // uint2str(expected%1000),
//             //         // "%"
//             //     )
//             // ));
//             // emit log(string(
//             //     abi.encodePacked(
//             //         "Actual      ",
//             //         uint2str(found[i])
//             //         // uint2str(f/1000),
//             //         // ".",
//             //         // uint2str(f%1000),
//             //         // "%\n"
//             //     )
//             // ));

//             assertLt(uint(abs(int(f) - int(expected))), 1000);
//         }

//         // assert(false);
//     }

//     function abs(int x) private pure returns (int) {
//         return x >= 0 ? x : -x;
//     }

//     function uint2str(
//         uint256 _i
//     )
//     internal
//     pure
//     returns (string memory str)
//     {
//         if (_i == 0)
//         {
//             return "0";
//         }
//         uint256 j = _i;
//         uint256 length;
//         while (j != 0)
//         {
//             length++;
//             j /= 10;
//         }
//         bytes memory bstr = new bytes(length);
//         uint256 k = length;
//         j = _i;
//         while (j != 0)
//         {
//             bstr[--k] = bytes1(uint8(48 + j % 10));
//             j /= 10;
//         }
//         str = string(bstr);
//     }
    
// }
