// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AliasPacked {
    //Percentage as a uint 0 -> 10000. 0.01% precision
    uint24[] public aliases;

    //2^12 -1 = 4095
    uint16 constant public PRECISION = (1 << 12) - 1;
    //4095 << 12 = 0xfff000. Bitmask to turn last 12 bits 1
    uint24 constant PROB_SHIFT = uint24(PRECISION) << 12;

    function init(uint[] memory weights) public {

        uint16 N = uint16(weights.length);
        uint weightSum = 0;

        //Normalize weights to be [0, PRECISION]
        unchecked {
            for (uint i = 0; i < N; i++) {
                weightSum += weights[i];
            }

            uint normal = PRECISION / weightSum;

            for (uint i = 0; i < N; i++) {
                weights[i] *= normal;
            }
        }

        uint avg = PRECISION/N;
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
        
        uint24[] memory al = new uint24[](N);

        
        unchecked {
            while (smallSize != 0 && largeSize != 0) {
                uint16 less = small[--smallSize];
                uint16 more = large[--largeSize];
                
                al[less] = encode(uint16(weights[less]) * N, more);
                
                if (weights[less] > avg)
                    weights[more] += weights[less] - avg;
                else
                    weights[more] -= avg - weights[less];
                
                if ((al[more] | PROB_SHIFT) < avg)
                    small[smallSize++] = more;
                else
                    large[largeSize++] = more;
            }

            while (smallSize != 0) {
                //set probability to 4095
                al[small[--smallSize]] |= PROB_SHIFT;
            }
                
            while (largeSize != 0) {
                //set probability to 4095
                al[large[--largeSize]] |= PROB_SHIFT;
            }
            
        }
        
        aliases = al;
    }

    function encode(uint16 probability, uint16 al) public pure returns(uint24 encoded) {
        encoded |= uint24(probability) << 12;
        encoded |= uint24(al);
    }

    function decode(uint24 encoded) public pure returns(uint16 probability, uint16 al) {
        probability = uint16(encoded >> 12);
        al = uint16(encoded) & PRECISION;
    }

    function precision() public pure returns(uint16) {
        return PRECISION;
    }
}