# SaiTok Token

This Solidity program implements a simple ERC20-like token contract named "SaiTok". The purpose of this contract is to allow users to mint and burn tokens, providing a basic framework for token management on the Ethereum blockchain.

## Description

The `SaiTok` contract allows for the creation (minting) and destruction (burning) of tokens. It maintains a total supply of tokens and tracks the balance of each account. This contract serves as a foundational example for those looking to understand token creation and management in Solidity.

### Key Features
- **Minting Tokens**: Users can create new tokens and assign them to a specified address.
- **Burning Tokens**: Users can destroy tokens from their own balance, reducing the total supply.
- **Public Variables**: The contract exposes the token name, symbol, and total supply for easy access.

## Getting Started

### Executing the Program

To run this program, you can use Remix, an online Solidity IDE. Follow these steps to get started:

1. Go to the Remix website at [https://remix.ethereum.org/](https://remix.ethereum.org/).
2. Create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a `.sol` extension (e.g., `SaiTok.sol`).
3. Copy and paste the following code into the file:
