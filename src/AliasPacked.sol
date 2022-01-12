// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {DSTest} from "ds-test/test.sol";
import {SSTORE2} from "solmate/utils/SSTORE2.sol";

library AliasPacked {
    //8191
    uint16 constant internal PRECISION = 2**13 - 1;
    //Bitmask to set probability to 8191
    bytes3 constant internal PROB_SHIFT = bytes3(uint24(PRECISION) << 11);

    uint constant internal DECIMALS = 1e6;

    //Tried making this more dynamic but wouldn't work as a constant
    //Stores the amount of bytes in a single uint24 
    //1 uint24, max of 0xffffff = 3 bytes
    uint constant internal BYTES_OFFSET = 3;

    function init(uint[] memory weights) internal returns(address) {
        // uint hh = gasleft();
        uint N = weights.length;
        
        //We need to squeeze our alias (index) into 11 bits. So no arrays longer than 2047 thanks
        require(N <= 2047);

        uint avg = uint(PRECISION)*DECIMALS/N;

        //Normalize weights to be (0, PRECISION]
        normalize(weights);

        uint16[] memory small = new uint16[](N);
        uint16[] memory large = new uint16[](N);

        uint smallSize = 0;
        uint largeSize = 0;

        unchecked {
            for (uint16 i = 0; i < N; i++) {
                if (weights[i] < avg)
                    small[smallSize++] = i;
                else
                    large[largeSize++] = i;
            }
        }
    
        bytes3[] memory al = new bytes3[](N);
        
        uint round = N*10;
        unchecked {
            while (smallSize != 0 && largeSize != 0) {
                uint16 less = small[--smallSize];
                uint16 more = large[--largeSize];
                
                uint wLess = weights[less];
                uint wMore = weights[more];
                //Round for higher accuracy
                al[less] = encodeB(uint16(((wLess * round/ DECIMALS)+5)/10), more);

                wMore = wMore + wLess - avg;
                weights[more] = wMore;
                
                if (wMore < avg * 987 / 1000)
                    small[smallSize++] = more;
                else
                    large[largeSize++] = more;
            }
    
            //set probability to 8191
            while (smallSize != 0)
                al[small[--smallSize]] |= PROB_SHIFT;
            
            //set probability to 8191
            while (largeSize != 0)
                al[large[--largeSize]] |= PROB_SHIFT;
            
        }

        return store(al);
    }

    function normalize(uint[] memory weights) private pure {
        uint N = weights.length;
        uint weightSum = 0;
        unchecked {
            for (uint i = 0; i < N; i++) {
                weightSum += weights[i];
            }

            uint norm = uint(PRECISION) * DECIMALS;
            for (uint i = 0; i < N; i++) {
                weights[i] = weights[i] * norm / weightSum;
            }
        }
    }

    function store(bytes3[] memory al) internal returns(address) {
        bytes memory b;
        uint N = al.length;
        uint last = N - (N % 90);
        unchecked {
            for (uint i = 0; i < N; i+=90) {
                if (i == last) {
                    bytes memory bTemp;
                    for (uint j = i; j < N; j++) {
                        bTemp = bytes.concat(bTemp, al[j]);
                    }
                    b = bytes.concat(b, bTemp);
                    break;
                } else {
                    bytes30 n1 = pack10Bytes3(al, i);
                    bytes30 n2 = pack10Bytes3(al, i+10);
                    bytes30 n3 = pack10Bytes3(al, i+20);
                    bytes30 n4 = pack10Bytes3(al, i+30);
                    bytes30 n5 = pack10Bytes3(al, i+40);
                
                    b = bytes.concat(b, n1, n2, n3, n4, n5);
                }
            }
        }
        
        return SSTORE2.write(b);
    }

    function pack10Bytes3(bytes3[] memory al, uint i) private pure returns(bytes30) {
        return (bytes30(al[i])) | 
                (bytes30(al[i+1]) >> 24) | 
                (bytes30(al[i+2]) >> 48) | 
                (bytes30(al[i+3]) >> 72) | 
                (bytes30(al[i+4]) >> 96) |
                (bytes30(al[i+5]) >> 120) |
                (bytes30(al[i+6]) >> 144) |
                (bytes30(al[i+7]) >> 168) |
                (bytes30(al[i+8]) >> 192) |
                (bytes30(al[i+9]) >> 216);
    }

    function encodeB(uint16 probability, uint16 al) internal pure returns(bytes3 encoded) {
        return bytes3((uint24(probability & 8191) << 11) | uint24(al & 2047));
    }

    function decodeB(bytes3 encoded) internal pure returns(uint16 probability, uint16 al) {
        probability = uint16(uint24(encoded >> 11) & 8191);
        al = uint16(uint24(encoded)) & 2047;
    }

    function pluck(bytes memory b, uint _column) internal pure returns(uint16 probability, uint16 al) {
        uint position = _column * BYTES_OFFSET;
        return decodeB(bytes3(b[position]) | (bytes3(b[position+1])>>8) | bytes3(b[position+2])>>16);
    }

    function getRandomIndex(bytes memory b, uint rand) internal pure returns(uint) {
        //Check this to make sure the rand is at least what we expect it to be
        require(rand > PRECISION);
        //This gets the amount of uint24's stored within the bytes
        //1 uint24 = 3 bytes.
        uint maxColumn = (b.length) / BYTES_OFFSET;
        //we first pick a random column to inspect the probability at
        //TODO: modulo bias... fix or accept it?
        uint column = rand % maxColumn;
        //We pluck the probability and alias out of the column
        (uint16 p, uint16 a) = pluck(b, column);
        //We check if the "decimal" portion of our random number is less than probability
        bool side = rand % PRECISION < p;
        //If it is, we return the column we chose earlier, else we choose the alias at that column
        return side ? column : a;
    }

    function toUint24(bytes memory _bytes) internal pure returns (uint24) {
        uint24 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x3), 0))
        }

        return tempUint;
    }

    function precision() internal pure returns(uint16) {
        return PRECISION;
    }
}