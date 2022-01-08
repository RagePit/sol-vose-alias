// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Alias {

    uint16[][5] public prob;
    uint16[][5] public aliases;

    uint constant public DECIMALS = type(uint16).max;

    function init(uint[] memory weights, uint index) public {
        uint N = weights.length;
        uint avg = DECIMALS*10000/N;

        weights = normalize(weights);

        // emit log_uint(avg);

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

        uint16 less = 0;
        uint16 more = 0;

        uint wLess = 0;
        uint wMore = 0;
        
        unchecked {
            while (smallSize != 0 && largeSize != 0) {
                
                less = small[--smallSize];
                more = large[--largeSize];
                
                wLess = weights[less];
                wMore = weights[more];

                //I believe this is mega scuffed
                // assertLe(wLess * N, DECIMALS*10000);
                // emit log_uint(DECIMALS - wLess * N / 10000);
                pr[less] = uint16(DECIMALS - wLess * N / 10000);
                
                al[less] = more;
                
                wMore = wMore + wLess - avg;
                weights[more] = wMore;

                // emit log_uint(wMore);

                //We need some amount of leniency due to our rounding
                if (wMore < avg * 995 / 1000) {
                    small[smallSize++] = more;
                    // emit log_named_uint("Small", more);
                } else {
                    large[largeSize++] = more;
                    // emit log_named_uint("Large", more);
                } 
            }
        }
        
            //These should be 0 already
            // while (smallSize != 0) 
            //     pr[small[--smallSize]] = 0;
            // while (largeSize != 0)
            //     pr[large[--largeSize]] = 0;
        

        prob[index] = pr;
        aliases[index] = al;
    }

    function normalize(uint[] memory weights) public pure returns(uint[] memory) {
        uint N = weights.length;
        uint weightSum = 0;

        unchecked {
            for (uint i = 0; i < N; i++) {
                weightSum += weights[i];
            }
        }
        
        unchecked {
            for (uint i = 0; i < N; i++) {
                weights[i] = (weights[i] * DECIMALS * 10000 / weightSum);
            }
        }

        return weights;
    }

    function probabilities(uint index) public view returns(uint16[] memory) {
        return prob[index];
    }

    function getAliases(uint index) public view returns(uint16[] memory) {
        return aliases[index];
    }
}