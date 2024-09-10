// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RWATOKEN {
    // ERC20 Variables
    string public name = "Real World Asset Token";
    string public symbol = "RWATOKEN";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    // Mapping for balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Constructor
    constructor(uint256 initialSupply) {
        owner = msg.sender; // Set deployer as owner
        totalSupply = initialSupply * 10**uint256(decimals);
        balanceOf[owner] = totalSupply; // Assign initial supply to the deployer
        emit Transfer(address(0), owner, totalSupply);
    }

    // Modifier to restrict functions to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Function to transfer ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // ERC20 Functions
    function transfer(address to, uint256 value) external returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool success) {
        require(value <= balanceOf[from], "Insufficient balance");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "Invalid address");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }

    // Token Value Management
    uint256 private tokenValue;

    // Function to set the value of RWATOKEN (only callable by owner)
    function setTokenValue(uint256 newValue) external onlyOwner {
        tokenValue = newValue;
    }

    // Function to get the current value of RWATOKEN
    function getTokenValue() external view returns (uint256) {
        return tokenValue;
    }

    // Mint new tokens (only owner can mint)
    function mint(address to, uint256 amount) external onlyOwner {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit TokensMinted(to, amount);
        emit Transfer(address(0), to, amount);
    }

    // Burn tokens (only callable by the holder)
    function burn(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit TokensBurned(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }
}

