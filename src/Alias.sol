// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {DSTest} from "ds-test/test.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract Alias {
    //Percentage as a uint 0 -> 65535. 
    uint16[] public prob;
    uint16[] public aliases;

    //2^16 -1 = 65535
    //0.0015% precision for probabilities
    uint16 constant public PRECISION = type(uint16).max;
    uint constant internal DECIMALS = 1e5;

    function init(uint[] memory weights) public {
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
                pr[less] = uint16(wLess * N);
                
                al[less] = more;
                
                wMore += wLess - avg;
                weights[more] = wMore;

                
                if (wMore < avg * 99 / 100)
                    small[smallSize++] = more;
                else
                    large[largeSize++] = more;
                    
            }

            while (smallSize != 0)
                pr[small[--smallSize]] = PRECISION;
            while (largeSize != 0)
                pr[large[--largeSize]] = PRECISION;
        }


        
        prob = pr;
        aliases = al;
    }

    function precision() public pure returns(uint) {
        return PRECISION;
    }

    function probabilities() public view returns(uint16[] memory) {
        return prob;
    }

    function getAliases() public view returns(uint16[] memory) {
        return aliases;
    }
}