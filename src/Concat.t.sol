// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.6;

// import {DSTest} from "ds-test/test.sol";
// import {SSTORE2} from "solmate/utils/SSTORE2.sol";

// import {AliasPacked} from "./AliasPacked.sol";
// import {BytesConcat} from "./BytesConcat.sol";

// contract ConcatTest is DSTest {

//     uint constant WEIGHT_LEN = 1000;
//     uint constant TEST_RUNS = 1;

//     uint[] weights;
//     uint weightSum;

//     uint24[] aliases;

//     function setUp() public {
        
//         uint[] memory _weights = new uint[](WEIGHT_LEN);
//         uint sum;

//         for(uint i = 0; i < WEIGHT_LEN; i++) {
//             uint r = uint(keccak256(abi.encode(i))) % 10000;
//             _weights[i] = r;
//             sum += r;
//         }

//         weightSum = sum;
//         weights = _weights;
        
//         aliases = AliasPacked.init(_weights);
//     } 

//     function testConcat10() public {
//         uint24[] memory al = aliases;
//         uint g = gasleft();
//         uint N = al.length;

//         bytes memory b;
        
//         for (uint i = 0; i < N; i+=10) {
//             b = bytes.concat(
//                     b,
//                     abi.encodePacked(al[i]),
//                     abi.encodePacked(al[i+1]),
//                     abi.encodePacked(al[i+2]),
//                     abi.encodePacked(al[i+3]),
//                     abi.encodePacked(al[i+4]),
//                     abi.encodePacked(al[i+5]),
//                     abi.encodePacked(al[i+6]),
//                     abi.encodePacked(al[i+7]),
//                     abi.encodePacked(al[i+8]),
//                     abi.encodePacked(al[i+9])
//                 );
//         }

//         emit log_named_uint("100x10 concat Gen Gas Used            ", g - gasleft());
//         emit log_named_uint("bytes.length            ", b.length);

//         g = gasleft();

//         address pointer = SSTORE2.write(b);

//         emit log_named_uint("SSTORE2 Cost", g - gasleft());
//         g = gasleft();

//         bytes memory read1 = SSTORE2.read(pointer, 0, 9);

//         emit log_named_uint("SSTORE2 Read 1 Cost", g - gasleft());

//         emit log_bytes(read1);
//         g = gasleft();

//         bytes memory read2 = bytes.concat(
//             abi.encodePacked(al[0]),
//             abi.encodePacked(al[1]),
//             abi.encodePacked(al[2])
//         );

//         emit log_bytes(read2);

//         g = gasleft();

//         bytes memory readWhole = SSTORE2.read(pointer);

//         emit log_named_uint("SSTORE2 Read Whole Cost", g - gasleft());

//         // emit log_bytes(readWhole);

//         assert(b.length == readWhole.length);

//         assert(false);
//     }

//     function testConcat20() public {
//         uint24[] memory al = aliases;
//         uint N = al.length;

//         uint g = gasleft();
//         bytes memory b = con20(al, N);

//         emit log_named_uint("50x20 concat Gen Gas Used            ", g - gasleft());
//         emit log_named_uint("bytes.length            ", b.length);

//         assert(false);
//     }

//     function con20(uint24[] memory al, uint N) public returns(bytes memory b) {
        
//             for (uint i = 0; i < N; i+=11) {
//                 if (i > 989) break;

//                 b = BytesConcat.concat(
//                         [
//                             b,
//                             abi.encodePacked(al[i]),
//                             abi.encodePacked(al[i+1]),
//                             abi.encodePacked(al[i+2]),
//                             abi.encodePacked(al[i+3]),
//                             abi.encodePacked(al[i+4]),
//                             abi.encodePacked(al[i+5]),
//                             abi.encodePacked(al[i+6]),
//                             abi.encodePacked(al[i+7]),
//                             abi.encodePacked(al[i+8]),
//                             abi.encodePacked(al[i+9]),
//                             abi.encodePacked(al[i+10])
//                         ]
//                     );
//             }
        
//     }
    
// }




