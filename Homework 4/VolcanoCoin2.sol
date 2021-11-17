// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

contract VolanoCoin{

uint totalSupply;

address owner;

modifier onlyOwner()   {
    if(msg.sender==owner){
        _;
    }
}

event SupplyChange(uint);


//Homework 4
// 1. In order to keep track of user balances, we need to associate a user’s address with thebalance that they have.
// a) What is the best data structure to hold this association ?
// Struct is the best data structure
// b) Using your choice of data structure, set up a variable called
// balance to keep track of the number of volcano coins that a user has.
struct Balance {
    address addr;
    uint amount;
}


//Homework 4
// 2. We want to allow the balance variable to be read from the contract, there are 2 ways todo this.
// a) What are those ways ?
// can use mappings
// can use structs
// b) Use one of the ways to make your balances variable visible to users of the contract.
mapping(address => uint) public balance_list;
// function getBalance(address user) public view returns (uint) {
//     return balance_list[user];
// }

// 3. Now change the constructor, to give all of the total supply to the owner of the contract.
constructor() {
    totalSupply = 10000;
    owner = msg.sender;
    balance_list[owner] = totalSupply;
} 

// 4. Now add a public function called transfer to allow a user to transfer their tokens toanother address.
// This function should have 2 parameters :
// the amount to transfer and
// the recipient address.
// 5. Add an event to the transfer function to indicate that a transfer has taken place, itshould record the amount and the recipient address.
event Transferred(address to, uint amount);

// 6. We want to keep a record for each user’s transfers. Create a struct called Payment that can be used to hold the transfer amount and the recipient’s address.
struct Payment {
    uint transfer_amount;
    address recipient_address;
}



// 7. We want to reference a payments array to each user sending the payment. Create a mapping which returns an array of Payment structs when given this user’s address.
mapping(address => Payment[]) public PaymentMapping;


function transfer (uint _quantity, address _recipient) public {
    balance_list[msg.sender] -= _quantity;
    balance_list[_recipient] += _quantity;    
    PaymentMapping[msg.sender].push(Payment(_quantity, _recipient));
    emit Transferred(_recipient, _quantity);
}
// 4. a) Why do we not need the sender’s address here ?
// because the sender will be initiating the transaction and can only spend his tokens
// 4. b) What would be the implication of having the sender’s address as a parameter?
// the sender will be able to spend tokens that do not belong to him



function AllTotalSupply() public view returns (uint) {
//    supply = _supply;
    return totalSupply;
}


//Make a function that can increase the total supply. Inside the function, add 1000 tokensto the current total supply.
//Make your increase total supply function public, but add your modifier so that only theowner can execute it.
function increaseSupply(uint _amount) public onlyOwner {
    totalSupply = totalSupply + _amount;
    emit SupplyChange(totalSupply);
}



}