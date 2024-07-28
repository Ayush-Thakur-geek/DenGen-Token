// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is Ownable, ERC20 {
    string public constant tokenName = "Degen Token";
    string public constant tokenSymbol = "DGN";
    string private listItems = "Items => 1 : armor : 10 | 2 : sword : 15 | 3 : elixor : 20";
    mapping(address => string[]) private inventory;
    mapping(uint => string) private items;
    mapping(string => uint) private itemPrices;
    mapping(address => uint) private toBeRedeemed;

    constructor(uint256 initialSupply) ERC20(tokenName, tokenSymbol) Ownable(msg.sender) {
        items[1] = "armor";
        items[2] = "sword";
        items[3] = "elixor";
        itemPrices["armor"] = 10;
        itemPrices["sword"] = 15;
        itemPrices["elixor"] = 20;
        _mint(msg.sender, initialSupply);
    }

    function store() public view returns (string memory) {
        return listItems;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        toBeRedeemed[to] += amount;
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public onlyOwner {
        uint256 currentAllowance = allowance(account, msg.sender);
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        _approve(account, msg.sender, currentAllowance - amount);
        _burn(account, amount);
    }

    function purchaseItems(uint256 itemId) public {
        require(itemId > 0 && itemId < 4, "Item not found");
        string memory item = items[itemId];
        uint256 itemPrice = itemPrices[item];
        require(balanceOf(msg.sender) >= itemPrice, "Insufficient balance");
        
        _transfer(msg.sender, owner(), itemPrice);
        inventory[msg.sender].push(item);
    }

    function viewInventory() public view returns (string[] memory) {
        return inventory[msg.sender];
    }

    function redeem() public {
        uint256 redeemAmount = toBeRedeemed[msg.sender];
        require(redeemAmount > 0, "Your redeem balance is zero");
        toBeRedeemed[msg.sender] = 0;
        _mint(msg.sender, redeemAmount);
    }
}
