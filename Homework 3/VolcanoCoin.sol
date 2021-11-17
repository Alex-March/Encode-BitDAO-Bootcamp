// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

contract VolanoCoin {
    //Create a variable to hold the total supply of 10000.
    uint256 public totalSupply;

    //Initialise an address variable called owner
    address owner;

    //create a modifier which only allows an owner to execute certain functions
    modifier onlyOwner() {
        if (msg.sender == owner) {
            _;
        }
    }

    event SupplyChange(uint256);

    //Create a variable to hold the total supply of 10000.
    //Create aconstructor and within the constructor, store the owner’s address.
    constructor() {
        totalSupply = 10000;
        owner = msg.sender;
    }

    //Make a public function that returns the total supply.
    function AllTotalSupply() public view returns (uint256) {
        //    supply = _supply;
        return totalSupply;
    }

    //Make a function that can increase the total supply. Inside the function, add 1000 tokensto the current total supply.
    //Make your increase total supply function public, but add your modifier so that only theowner can execute it.
    function increaseSupply(uint256 _amount) public onlyOwner {
        totalSupply = totalSupply + _amount;
        emit SupplyChange(totalSupply);
    }
}
