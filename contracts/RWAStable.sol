// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract RWAUSD is ERC20, Ownable2Step {
    constructor() ERC20("Real World Asset USD", "RWAUSD") {
        // Optionally mint an initial supply, if needed
        // _mint(msg.sender, initial_supply);
    }

    // Events
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    // Function to mint new tokens
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    // Function to burn tokens from the caller's account
    function burn(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
}

