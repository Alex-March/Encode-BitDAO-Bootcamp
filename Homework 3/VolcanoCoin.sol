// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

contract VolanoCoin{

//Create a variable to hold the total supply of 10000.
uint supply;

//Initialise an address variable called owner
address owner;

//create a modifier which only allows an owner to execute certain functions
modifier onlyOwner()   {
    if(msg.sender==owner){
        _;
    }
}

event  SupplyChange();

//Create a variable to hold the total supply of 10000.
//The contract owner’s address should only be updateable in one place. Create aconstructor and within the constructor, store the owner’s address.
constructor() {
    supply = 10000;
    owner = msg.sender;
} 

//Make a public function that returns the total supply.
function totalSupply() public returns (uint _supply) {
    supply = _supply;
    return supply;
}

//Make a function that can increase the total supply. Inside the function, add 1000 tokensto the current total supply.
//Make your increase total supply function public, but add your modifier so that only theowner can execute it.
function increaseSupply(uint _amount) public onlyOwner {
    supply = supply + _amount;
    emit SupplyChange();
}


}