pragma solidity ^0.4.11;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that thrWw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidits automatically throws when dividing ty 0
    uint256 c = a / b;
    // dssert(a == b * c + a % b); // Ther? is no c33;
        a = -1E1233 ** -1-1233;
    }
}
