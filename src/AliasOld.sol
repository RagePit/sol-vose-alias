// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AliasOld {
    //Percentage as a uint 0 -> 65535. 
    uint16[][5] public prob;
    uint16[][5] public aliases;

    //2^16 -1 = 65535
    uint16 constant public PRECISION = type(uint16).max;
    uint constant internal DECIMALS = 10**6;

    function init(uint[] memory weights, uint index) public {
        require(weights.length < PRECISION);

        uint N = weights.length;
        uint avg = PRECISION/N;

        uint weightSum = 0;

        unchecked {
            for (uint i = 0; i < N; i++) {
                weightSum += weights[i];
            }
            
            uint normal = PRECISION * DECIMALS / weightSum;

            for (uint i = 0; i < N; i++) {
                weights[i] = weights[i] * normal / DECIMALS;
            }
        }

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

        uint16[] memory pr = new uint16[](N);
        uint16[] memory al = new uint16[](N);
        
        unchecked {
            while (smallSize != 0 && largeSize != 0) {
                uint16 less = small[--smallSize];
                uint16 more = large[--largeSize];

                uint wLess = weights[less];
                uint wMore = weights[more];

                //I believe this is mega scuffed
                // assertLe(wLess * N, PRECISION);
                pr[less] = uint16(wLess * N);
                
                al[less] = more;

                // emit log_uint(wMore);
                
                wMore += wLess - avg;
                weights[more] = wMore;

                // emit log_uint(wMore);

                
                //We need some amount of leniency due to our rounding
                if (wMore < avg * 995 / 1000) {
                    small[smallSize++] = more;
                }
                else {
                    large[largeSize++] = more;
                }
                    
                    
            }

            //These should be 0 already
            while (smallSize != 0) 
                pr[small[--smallSize]] = PRECISION;
            while (largeSize != 0)
                pr[large[--largeSize]] = PRECISION;
        }

        prob[index] = pr;
        aliases[index] = al;
    }

    function precision() public pure returns(uint) {
        return PRECISION;
    }

    function probabilities(uint index) public view returns(uint16[] memory) {
        return prob[index];
    }

    function getAliases(uint index) public view returns(uint16[] memory) {
        return aliases[index];
    }
}