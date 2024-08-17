// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenLock is Ownable {
    struct Lock {
        uint256 amount;
        uint256 unlockTime;
    }

    IERC20 public token;
    mapping(address => Lock) public lockedTokens;

    constructor(IERC20 _token) Ownable(msg.sender) {
        token = _token;
    }

    function lockTokens(uint256 amount) public {
        require(lockedTokens[msg.sender].amount == 0, "Tokens already locked");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        lockedTokens[msg.sender] = Lock({
            amount: amount,
            unlockTime: block.timestamp + 126200000 //4 years
        });
    }

    function unlockTokens() public {
        require(block.timestamp >= lockedTokens[msg.sender].unlockTime, "Tokens are still locked");
        uint256 amount = lockedTokens[msg.sender].amount;
        require(amount > 0, "No tokens to unlock");

        lockedTokens[msg.sender].amount = 0;
        require(token.transfer(msg.sender, amount), "Transfer failed");
    }
}

