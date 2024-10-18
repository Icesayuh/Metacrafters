# SaiTok Token Contract

This Solidity program implements a simple ERC20-like token contract named "SaiTok". The purpose of this contract is to allow users to mint and burn tokens, providing a basic framework for token management on the Ethereum blockchain.

## Description

The `SaiTok` contract allows for the creation (minting) and destruction (burning) of tokens. It maintains a total supply of tokens and tracks the balance of each account. This contract serves as a foundational example for those looking to understand token creation and management in Solidity.

### Key Features
- **Minting Tokens**: Users can create new tokens and assign them to a specified address using the `createTokens` function.
- **Burning Tokens**: Users can destroy tokens from their own balance, reducing the total supply, through the `destroyTokens` function.
- **Custom Error Handling**: The contract includes a custom error `InsufficientBalance` to provide clear feedback when a user attempts to withdraw more tokens than they have.
- **Assertions**: The contract uses assertions to ensure that the total token supply remains valid.
- **Event Logging**: The contract emits an event `TotalTokenSupplyChecked` to log the total supply whenever it is checked.

## Getting Started

### Prerequisites
- Ensure you have a compatible Ethereum wallet and some Ether for testing.
- Use Remix, an online Solidity IDE, to deploy and interact with the contract.

### Executing the Program

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file and paste the `SaiTok` contract code.
3. Compile the contract using the Solidity compiler.
4. Deploy the contract to the JavaScript VM or any test network.
5. Use the deployed contract's functions to mint and burn tokens.

## Authors
Isaiah Ezekiel E. Guevarra | 202110093
