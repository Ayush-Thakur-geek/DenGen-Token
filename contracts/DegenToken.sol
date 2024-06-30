// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    string public listItems =
        "Items => 1 : armor : 10 | 2 : sword : 15 | 3 : elixor : 20";
    mapping(address => string[]) private inventory;
    mapping(uint => string) private items;
    mapping(string => uint) private itemPrices;
    mapping(address => uint) private toBeRedeemed;
    mapping(address => uint) private balance;
    uint private totalTokens = 0;

    constructor(
        uint initialSupply
    ) ERC20("DegenToken", "DGN") Ownable(msg.sender) {
        items[1] = "armor";
        items[2] = "sword";
        items[3] = "elixor";
        itemPrices["armor"] = 10;
        itemPrices["sword"] = 15;
        itemPrices["elixor"] = 20;
        mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        toBeRedeemed[to] += amount;
        totalTokens += amount;
    }

    function totalSupply() public view override returns (uint) {
        return totalTokens;
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burn(uint256 amount) public override onlyOwner {
        _burn(msg.sender, amount);
    }

    function burnFrom(
        address account,
        uint256 amount
    ) public override onlyOwner {
        require(
            balanceOf(account) >= amount,
            "ERC20: burn amount exceeds balance"
        );
        _burn(account, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override onlyOwner returns (bool) {
        require(
            balanceOf(sender) >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _transfer(sender, recipient, amount);
        return true;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balance[account];
    }

    function purchaseItems(uint256 itemId) public {
        require(itemId > 0 && itemId < 4, "Item not found");
        string storage item = items[itemId];

        require(
            balanceOf(msg.sender) >= itemPrices[item],
            "Insufficient balance"
        );

        inventory[msg.sender].push(item);

        transferFrom(msg.sender, owner(), itemPrices[item]);
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
