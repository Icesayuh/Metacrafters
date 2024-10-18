// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SaiTok {
    // Public variables that store information about my token
    string public tokenName = "SaiTok";
    string public tokenSymbol = "SAI";
    uint256 public totalTokenSupply = 0; //will grow through minting

    // Mapping of addresses to balances
    mapping(address => uint256) public accountBalance;

    // Function to create new tokens (mint)
    function createTokens(address recipient, uint256 value) public {
        // Check if the value is positive
        require(value > 0, "Must create a positive amount of tokens");
        // Increase the total token supply
        totalTokenSupply += value;
        // Increase the balance of the recipient address
        accountBalance[recipient] += value;
    }

    // Function to destroy tokens (burn)
    function destroyTokens(address owner, uint256 value) public {
        // Check if the value is positive
        require(value > 0, "Must destroy a positive amount of tokens");
        // Check if the balance of the owner is sufficient
        require(accountBalance[owner] >= value, "Not enough tokens to destroy");
        // Decrease the total token supply
        totalTokenSupply -= value;
        // Decrease the balance of the owner address
        accountBalance[owner] -= value;
    }
}