# Real Estate Tokenization Smart Contract

This repository contains Solidity smart contracts that enable the fractionalization of real estate properties into ERC-20 tokens on the Ethereum blockchain. These contracts allow property owners to tokenize real estate, and investors to purchase and trade fractional ownership securely.

## Overview

The system consists of two main contracts:

1. **PropertyToken**: An ERC-20 compliant token representing fractional ownership of a single property
Deployed address on polygon : 0xbF87af3C9eC0C86dEF0a66156DDe41167df95C23 
2. **PropertyTokenFactory**: A factory contract that creates and manages multiple PropertyToken contracts
Deployed address on polygon : 0xa4d30c2012Cea88c81e4b291dD689D5250a8fB11  

## Features

- Creation of unique ERC-20 tokens for each property
- Storage of property metadata on-chain (ID, value, documentation references)
- Fixed token supply based on property valuation
- Standard ERC-20 transfer functions for token ownership
- Admin-only minting upon property onboarding
- Property details and token price calculation

## Contract Architecture

```
PropertyTokenFactory
│
└── Creates and manages
    │
    ├── PropertyToken 1 (ERC-20)
    ├── PropertyToken 2 (ERC-20)
    └── PropertyToken N (ERC-20)
```

## Technical Flow

### 1. Initial Setup and Deployment

1. Deploy the `PropertyTokenFactory` contract
   - This contract will be the central point for creating and tracking all property tokens
   - The deployer becomes the admin/owner of the factory

### 2. Property Tokenization Process

1. Admin calls `createPropertyToken` on the factory with property details:
   - Token name and symbol
   - Unique property identifier
   - Property valuation
   - Total token supply to mint
   - Property documentation reference (e.g., IPFS hash)

2. The factory:
   - Creates a new `PropertyToken` contract
   - Initializes the property with provided details
   - Mints the total supply of tokens to the admin
   - Transfers ownership of the token contract to the admin
   - Registers the new token in its internal registry
   - Emits a `PropertyTokenCreated` event

### 3. Token Distribution

1. Admin transfers tokens to investors:
   - Using standard ERC-20 `transfer` or `transferFrom` functions
   - Each token represents fractional ownership of the property
   - Price per token is calculated as property value / total supply

### 4. Ownership Management

1. Investors can:
   - Hold tokens to maintain property ownership
   - Transfer tokens to other addresses to sell ownership
   - Use tokens in other DeFi applications (lending, DEXs, etc.)

2. Admin can:
   - Update property documentation references
   - View all registered properties through the factory

## Functions Reference

### PropertyTokenFactory

- `createPropertyToken`: Creates a new PropertyToken contract
- `getPropertyTokenCount`: Returns the number of created property tokens
- `getAllPropertyTokens`: Returns addresses of all created tokens
- `propertyExists`: Checks if a property ID is already registered

### PropertyToken

- `initializeProperty`: Sets up property details and mints tokens (admin only)
- `updatePropertyDocumentation`: Updates property documentation reference (admin only)
- `getTokenPrice`: Calculates price per token based on property value
- `getPropertyDetails`: Returns all property metadata
- Standard ERC-20 functions: `transfer`, `transferFrom`, `balanceOf`, etc.

## Security Considerations

- Only the admin can create new property tokens and initialize properties
- Property IDs must be unique to prevent duplication
- Token supply is fixed at creation and cannot be changed
- All standard ERC-20 security considerations apply

## Integration Guide

1. Deploy the `PropertyTokenFactory` contract
2. For each property:
   - Call `createPropertyToken` with appropriate details
   - Distribute tokens to investors
3. Users can interact with tokens using any ERC-20 compatible wallet

## Example Use Case

1. A property worth 1,000,000 USD is tokenized into 1,000 tokens
2. Each token represents 0.1% ownership worth 1,000 USD
3. Investors can purchase as few or as many tokens as they want
4. Tokens can be freely traded on secondary markets

## Testing on Remix

1. Compile and deploy `PropertyTokenFactory`
2. Create a property token with test values
3. Test token transfers between accounts
4. Verify property details and token balances

## License

This project is licensed under the MIT License.