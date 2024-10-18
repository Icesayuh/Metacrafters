// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SaiTok {
    // Public variables that store information about my token
    string public tokenName = "SaiTok";
    string public tokenSymbol = "SAI";
    uint256 public totalTokenSupply = 0; // will grow through minting

    // Mapping of addresses to balances
    mapping(address => uint256) public accountBalance;

    // Custom error for insufficient balance
    error InsufficientBalance(uint balance, uint withdrawAmount);

    // Event to log totalTokenSupplyL
    event TotalTokenSupplyChecked(uint256 totalSupply);

    // Function to create new tokens (mint)
    function createTokens(address recipient, uint256 value) public {
        // Using require to validate input: must create a positive amount of tokens
        require(value > 0, "Must create a positive amount of tokens");
        
        // Update total supply and recipient's balance
        totalTokenSupply += value;
        accountBalance[recipient] += value;
    }

    // Function to destroy tokens (burn)
    function destroyTokens(address owner, uint256 value) public {
        // Using require to ensure the value to destroy is positive
        require(value > 0, "Must destroy a positive amount of tokens");  // Has require()
        
        // Using require to check if the owner has enough tokens to destroy
        require(accountBalance[owner] >= value, "Not enough tokens to destroy");
        
        // Update total supply and owner's balance
        totalTokenSupply -= value;
        accountBalance[owner] -= value;
    }

    // Function to demonstrate assert()
    function testAssert() public {
        // Emit the event before the assertion to log the current totalTokenSupply
        emit TotalTokenSupplyChecked(totalTokenSupply);
        
        // Using assert to check for internal invariants: totalTokenSupply should never be negative
        assert(totalTokenSupply >= 1); // Has assert()
    }

    // Function to demonstrate custom error with revert
    function testCustomError(uint _withdrawAmount) public view {
        uint bal = accountBalance[msg.sender];
        
        // Using revert with a custom error to handle insufficient balance
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount}); // Has revert() to test 
        }
    }
}