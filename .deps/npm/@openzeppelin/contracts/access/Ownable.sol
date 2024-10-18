// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import the ERC20 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // Correct import for ERC20
import "@openzeppelin/contracts/access/Ownable.sol"; // Correct import for Ownable

contract SimpleERC20 is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("SimpleToken", "STK") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}