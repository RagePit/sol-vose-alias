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
    
        bytes memory al = new bytes(N*3);
        
        uint round = N*10;
        unchecked {
            while (smallSize != 0 && largeSize != 0) {
                uint16 less = small[--smallSize];
                uint16 more = large[--largeSize];
                
                uint wLess = weights[less];
                //Round for higher accuracy
                bytes3 toStore = encodeB(uint16(((wLess * round/ DECIMALS)+5)/10), more);
                less = less*3;
                al[less] = bytes1(toStore);
                al[less+1] = bytes1(toStore<<8);
                al[less+2] = bytes1(toStore<<16);

                weights[more] += wLess - avg;
                
                if (weights[more] < avg)
                    small[smallSize++] = more;
                else
                    large[largeSize++] = more;
            }
    
            //set probability to 8191
            while (smallSize != 0) {
                uint16 ind = small[--smallSize]*3;

                al[ind] = bytes1(PROB_SHIFT);
                al[ind+1] = bytes1(PROB_SHIFT<<8);
                al[ind+2] = bytes1(PROB_SHIFT<<16);
            }
                
            //set probability to 8191
            while (largeSize != 0) {
                uint16 ind = large[--largeSize]*3;

                al[ind] = bytes1(PROB_SHIFT);
                al[ind+1] = bytes1(PROB_SHIFT<<8);
                al[ind+2] = bytes1(PROB_SHIFT<<16);
            }
            
        }

        return SSTORE2.write(al);
    }

    function normalize(uint[] memory weights) internal pure {
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

    function precision() internal pure returns(uint16) {
        return PRECISION;
    }
}