// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract DegenToken is Ownable {
    string public name = "Degen Token";
    string public symbol = "DGN";
    string private listItems =
        "Items => 1 : armor : 10 | 2 : sword : 15 | 3 : elixor : 20";
    mapping(address => string[]) private inventory;
    mapping(uint => string) private items;
    mapping(string => uint) private itemPrices;
    mapping(address => uint) private toBeRedeemed;
    mapping(address => uint) private balance;
    uint private totalTokens = 0;

    constructor(uint initialSupply) Ownable(msg.sender) {
        items[1] = "armor";
        items[2] = "sword";
        items[3] = "elixor";
        itemPrices["armor"] = 10;
        itemPrices["sword"] = 15;
        itemPrices["elixor"] = 20;
        mint(msg.sender, initialSupply);
    }

    function store() public view returns (string memory) {
        return listItems;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        toBeRedeemed[to] += amount;
        totalTokens += amount;
    }

    function totalSupply() public view returns (uint) {
        return totalTokens;
    }

    function decimals() public pure returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burn(uint256 amount) public {
        require(balance[msg.sender] >= amount, "Not enough balance");
        balance[msg.sender] -= amount;
        totalTokens -= amount;
    }

    function burnFrom(address account, uint256 amount) public onlyOwner {
        require(
            balanceOf(account) >= amount,
            "ERC20: burn amount exceeds balance"
        );
        balance[account] -= amount;
        totalTokens -= amount;
    }

    function transfer(address to, uint value) public returns (bool) {
        require(balanceOf(msg.sender) >= value, "Not enough balance");
        balance[msg.sender] -= value;
        balance[to] += value;
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public onlyOwner returns (bool) {
        require(
            balanceOf(sender) >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        balance[sender] -= amount;
        balance[recipient] += amount;
        return true;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balance[account];
    }

    function purchaseItems(uint256 itemId) public {
        require(itemId > 0 && itemId < 4, "Item not found");
        string memory item = items[itemId];

        require(
            balanceOf(msg.sender) >= itemPrices[item],
            "Insufficient balance"
        );

        inventory[msg.sender].push(item);

        transfer(owner(), itemPrices[item]);
    }

    function viewInventory() public view returns (string[] memory) {
        return inventory[msg.sender];
    }

    function redeem() public returns (uint) {
        require(toBeRedeemed[msg.sender] > 0, "Your redeem balance is zero");
        balance[msg.sender] += toBeRedeemed[msg.sender];
        return toBeRedeemed[msg.sender];
    }
}
