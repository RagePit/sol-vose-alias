// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.0;

// library BytesConcat  {

//     //2 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2
//         );
//     }

//     //3 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3
//         );
//     }

//     //4 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4
//         );
//     }

//     //5 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5
//         );
//     }

//     //6 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6
//         );
//     }

//     //7 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7
//         );
//     }

//     //8 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8
//         );
//     }

//     //9 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9
//         );
//     }

//     //10 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9, 
//         bytes memory b10
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10
//         );
//     }

//     //11 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11
//         );
//     }

//     //12 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12
//         );
//     }

//     function concat(bytes[12] memory b) internal pure returns(bytes memory bb) {
//         bb = bytes.concat(
//                 b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11]
//             );
//     }

//     //13 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12,
//         bytes memory b13     
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13
//         );
//     }

//     //14 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12,
//         bytes memory b13,
//         bytes memory b14
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14
//         );
//     }

//     //15 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12,
//         bytes memory b13,
//         bytes memory b14,
//         bytes memory b15        
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15
//         );
//     }

//     //16 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12,
//         bytes memory b13,
//         bytes memory b14,
//         bytes memory b15,
//         bytes memory b16
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16
//         );
//     }

//     //17 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12,
//         bytes memory b13,
//         bytes memory b14,
//         bytes memory b15,
//         bytes memory b16,
//         bytes memory b17
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17
//         );
//     }

//     //21 bytes
//     function concat(
//         bytes memory b1, 
//         bytes memory b2, 
//         bytes memory b3, 
//         bytes memory b4,
//         bytes memory b5, 
//         bytes memory b6, 
//         bytes memory b7, 
//         bytes memory b8, 
//         bytes memory b9,
//         bytes memory b10,
//         bytes memory b11,
//         bytes memory b12,
//         bytes memory b13,
//         bytes memory b14,
//         bytes memory b15,
//         bytes memory b16,
//         bytes memory b17,
//         bytes memory b18,
//         bytes memory b19,
//         bytes memory b20,
//         bytes memory b21
//     ) internal pure returns(bytes memory) {
//         return bytes.concat(
//             b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21
//         );
//     }
    
// }




