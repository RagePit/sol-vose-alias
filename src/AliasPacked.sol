// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {DSTest} from "ds-test/test.sol";
import {SSTORE2} from "solmate/utils/SSTORE2.sol";

library AliasPacked {
    //8191
    uint16 constant internal PRECISION = 2**13 - 1;
    //Bitmask to set probability to 8191
    uint24 constant internal PROB_SHIFT = uint24(PRECISION) << 11;

    uint constant internal DECIMALS = 1e5;

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
        // uint g = gasleft();

        //Normalize weights to be [0, PRECISION]
        weights = normalize(weights);

        // emit log_named_uint("   Normalization", g - gasleft());
        // g = gasleft();

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

        // emit log_named_uint("   Indices Arrays", g - gasleft());
        // g = gasleft();
    

        uint24[] memory al = new uint24[](N);
        
        unchecked {
            while (smallSize != 0 && largeSize != 0) {
                uint16 less = small[--smallSize];
                uint16 more = large[--largeSize];
                
                uint wLess = weights[less];
                uint wMore = weights[more];

                al[less] = encode(uint16(((wLess * N / DECIMALS)+5)/10), more);

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

        // emit log_named_uint("   Main Algorithm", g - gasleft());
        // g = gasleft();


        return store(al);
        
    }

    function store(uint24[] memory al) internal returns(address) {
        bytes memory b;
        uint N = al.length;
        for (uint i = 0; i < N; i+=5) {
            b = bytes.concat(
                    b,
                    abi.encodePacked(al[i]),
                    abi.encodePacked(al[i+1]),
                    abi.encodePacked(al[i+2]),
                    abi.encodePacked(al[i+3]),
                    abi.encodePacked(al[i+4])
                    // abi.encodePacked(al[i+5]),
                    // abi.encodePacked(al[i+6]),
                    // abi.encodePacked(al[i+7]),
                    // abi.encodePacked(al[i+8]),
                    // abi.encodePacked(al[i+9])
                );
        }
        return SSTORE2.write(b);
    }

    function normalize(uint[] memory weights) internal pure returns(uint[] memory) {
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

        return weights;
    }

    function precision() internal pure returns(uint16) {
        return PRECISION;
    }

    function encode(uint16 probability, uint16 al) internal pure returns(uint24 encoded) {
        encoded |= uint24(probability) << 11;
        encoded |= uint24(al & 2047);
    }

    function decode(uint24 encoded) internal pure returns(uint16 probability, uint16 al) {
        probability = uint16(encoded >> 11);
        al = uint16(encoded) & 2047;
    }

    function pluck(address _pointer, uint _column) internal view returns(uint16 probability, uint16 al) {
        uint position = _column * BYTES_OFFSET;
        return decode(toUint24(SSTORE2.read(_pointer, position, position + BYTES_OFFSET)));
    }

    function getRandomIndex(address _pointer, uint rand) internal view returns(uint) {
        //Check this to make sure the rand is at least what we expect it to be
        require(rand > PRECISION);
        //This gets the amount of uint24's stored within the pointer
        //1 uint24 = 3 bytes.
        uint maxColumn = (_pointer.code.length - SSTORE2.DATA_OFFSET) / BYTES_OFFSET;
        //we first pick a random column to inspect the probability at
        uint column = rand % maxColumn;
        //We pluck the probability and alias out of the column
        (uint16 p, uint16 a) = pluck(_pointer, column);
        //We check if the "decimal" portion of our random number is less than probability
        bool side = rand % PRECISION < p;
        //If it is, we return the column we chose earlier, else we choose the alias at that column
        return side ? column : a;
    }

    function toUint24(bytes memory _bytes) internal pure returns (uint24) {
        // require(_bytes.length >= _start + 3, "toUint24_outOfBounds");
        uint24 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x3), 0))
        }

        return tempUint;
    }
}