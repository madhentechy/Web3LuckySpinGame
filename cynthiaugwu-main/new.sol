// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LuckySpin {
    address public owner;
    uint256 public spinCost = 0.01 ether;
    string[] public motivationalQuotes;
    
    event SpinResult(address indexed player, string quote);
    
    constructor() {
        owner = msg.sender;
        motivationalQuotes.push("0 CRYPTO");
        motivationalQuotes.push("5 USDC");
        motivationalQuotes.push("0.2 BNB");
        motivationalQuotes.push("5 USDT");
        motivationalQuotes.push("0.12 ETH");
        motivationalQuotes.push("1 USDC");
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
    
    function addQuote(string memory quote) public onlyOwner {
        motivationalQuotes.push(quote);
    }
    
    function removeQuote(uint256 index) public onlyOwner {
        require(index < motivationalQuotes.length, "Invalid index.");
        motivationalQuotes[index] = motivationalQuotes[motivationalQuotes.length - 1];
        motivationalQuotes.pop();
    }
    
    function setSpinCost(uint256 cost) public onlyOwner {
        spinCost = cost;
    }
    
    function getQuoteCount() public view returns (uint256) {
        return motivationalQuotes.length;
    }
    
    function spin() public payable {
        require(msg.value >= spinCost, "Not enough ether sent.");
        
        uint256 quoteIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % motivationalQuotes.length;
        string memory quote = motivationalQuotes[quoteIndex];
        
        emit SpinResult(msg.sender, quote);
    }
    
    function withdrawBalance() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}