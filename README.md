# DegenToken Smart Contract

## Introduction

`DegenToken` is a custom ERC20-like token designed specifically for a gaming ecosystem. This smart contract allows the contract owner to mint and burn tokens, facilitate token transfers between users, and manage a virtual store where users can purchase items using their tokens. Additionally, it provides functionality for users to view and redeem their token balances, and keep track of their purchased items.

## Features

- **Token Management**: 
  - Minting new tokens to specified addresses.
  - Burning tokens from the owner's or user's balance.
  - Transferring tokens between users.
  
- **Store Management**: 
  - Users can purchase in-game items using their tokens.
  
- **Balance Management**: 
  - Users can view their token balances.
  - Users can redeem their tokens to be added to their balance.
  
- **Inventory Management**: 
  - Users can view the items they have purchased.

## Contract Details

### Variables

- **name**: The name of the token, set to "Degen Token".
- **symbol**: The token symbol, set to "DGN".
- **listItems**: A string listing available items and their prices.
- **inventory**: A mapping of user addresses to their purchased items.
- **items**: A mapping of item IDs to item names.
- **itemPrices**: A mapping of item names to their prices in tokens.
- **toBeRedeemed**: A mapping of user addresses to the number of tokens available for redemption.
- **balance**: A mapping of user addresses to their token balances.
- **totalTokens**: The total supply of tokens in circulation.

### Functions

- **store()**: 
  - **Returns**: A string of available items and their prices.
  - **Usage**: `string memory itemsList = token.store();`
  
- **mint(address to, uint256 amount)**: 
  - **Parameters**: `to` (address to mint tokens to), `amount` (number of tokens to mint).
  - **Usage**: `token.mint("0xRecipientAddress", 100);`
  
- **totalSupply()**: 
  - **Returns**: The total supply of tokens.
  - **Usage**: `uint total = token.totalSupply();`
  
- **decimals()**: 
  - **Returns**: The number of decimals for the token, set to 0.
  - **Usage**: `uint8 decimals = token.decimals();`
  
- **getBalance()**: 
  - **Returns**: The balance of the calling address.
  - **Usage**: `uint256 balance = token.getBalance();`
  
- **burn(uint256 amount)**: 
  - **Parameters**: `amount` (number of tokens to burn).
  - **Usage**: `token.burn(50);`
  
- **burnFrom(address account, uint256 amount)**: 
  - **Parameters**: `account` (address from which tokens are burned), `amount` (number of tokens to burn).
  - **Usage**: `token.burnFrom("0xAccountAddress", 30);`
  
- **transfer(address to, uint value)**: 
  - **Parameters**: `to` (recipient address), `value` (number of tokens to transfer).
  - **Returns**: `bool` indicating success.
  - **Usage**: `bool success = token.transfer("0xRecipientAddress", 20);`
  
- **transferFrom(address sender, address recipient, uint256 amount)**: 
  - **Parameters**: `sender` (address to transfer from), `recipient` (address to transfer to), `amount` (number of tokens to transfer).
  - **Returns**: `bool` indicating success.
  - **Usage**: `bool success = token.transferFrom("0xSenderAddress", "0xRecipientAddress", 10);`
  
- **balanceOf(address account)**: 
  - **Parameters**: `account` (address to check the balance of).
  - **Returns**: The token balance of the specified address.
  - **Usage**: `uint256 balance = token.balanceOf("0xAccountAddress");`
  
- **purchaseItems(uint256 itemId)**: 
  - **Parameters**: `itemId` (ID of the item to purchase).
  - **Usage**: `token.purchaseItems(1);`
  
- **viewInventory()**: 
  - **Returns**: The list of items in the caller's inventory.
  - **Usage**: `string[] memory items = token.viewInventory();`
  
- **redeem()**: 
  - **Returns**: The number of tokens redeemed.
  - **Usage**: `uint256 redeemed = token.redeem();`

## Deployment

### Prerequisites

- **Node.js and npm**: Ensure you have [Node.js](https://nodejs.org/) and npm installed.
- **Hardhat**: Install Hardhat by running the following command:

    ```bash
    npm install --save-dev hardhat
    ```

- **Ether.js**: Hardhat uses Ether.js by default for interactions.

### Steps

1. **Clone the Repository**

    ```bash
    git clone https://github.com/your-repo/DegenToken.git
    cd DegenToken
    ```

2. **Install Dependencies**

    ```bash
    npm install
    ```

3. **Compile the Contract**

    ```bash
    npx hardhat compile
    ```

4. **Deploy the Contract**

    Create a deployment script `scripts/deploy.js`:

    ```javascript
    async function main() {
        const DegenToken = await ethers.getContractFactory("DegenToken");
        const initialSupply = 1000;
        const token = await DegenToken.deploy(initialSupply);
        await token.deployed();
        console.log("DegenToken deployed to:", token.address);
    }

    main().catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
    ```

    Run the deployment script:

    ```bash
    npx hardhat run scripts/deploy.js --network <your_network>
    ```

    Replace `<your_network>` with the network you are deploying to, e.g., `rinkeby`, `mainnet`, etc.

## Interaction

### Viewing Store Items

Use the `store()` function to get the list of available items:

```javascript
const itemsList = await token.store();
console.log(itemsList);
