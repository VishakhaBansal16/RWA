// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";



contract RWAUSD is ERC20, Ownable2Step  {
    uint256 private constant _TOTAL_SUPPLY = 500 * 10**9 * 10**18; // 500 billion tokens with 18 decimals

    constructor() ERC20("Real World Asset USD", "RWAUSD") Ownable(msg.sender) {
        // Mint the total supply to the owner's address
        _mint(msg.sender, _TOTAL_SUPPLY);
    }


    //events:
    event TokensMinted(address indexed to, uint256 amount);
event TokensBurned(address indexed from, uint256 amount);


    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
         emit TokensMinted(to, amount);
    }

    function burn(uint256 amount) external {
        require(balanceOf(msg.sender) > amount, "Insufficient balance to burn");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
}
