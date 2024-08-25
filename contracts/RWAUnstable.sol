// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RWATOKEN is ERC20, Ownable {
    uint256 private tokenValue; 
    uint256 public constant TOTAL_SUPPLY = 100 * 10**9 * 10**18;

    constructor() ERC20("Real World Asset Token", "RWATOKEN") Ownable(msg.sender) {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    // Function to set the value of WRATOKEN
    function setTokenValue(uint256 newValue) external onlyOwner {
        tokenValue = newValue;
    }

    // Function to get the current value of WRATOKEN
    function getTokenValue() external view returns (uint256) {
        return tokenValue;
    }
}
