// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;


/*
Contract that allows users to interact with it to claim some funds when the status is "green light"
0 = green light, 1 = red light
*/

contract RedLightGreenLight {
    uint public lightStatus;
    address owner;
    modifier onlyOwner()   {
        if(msg.sender==owner){
            _;
        }
    }
    
    event LightSet (uint);    

    constructor() {
        owner = msg.sender;
        // status of the contract = 1 for red light upon deployment
        lightStatus = 1;
    }
    // first need to set a function for setting the light status to red light by default, and then allowing it to be updated to green light by the owner
    
    // function so that only the owner can change the light to red/green. The value of 0 is green light, all other values return 1, which stands for red light
    function setLight(uint _lightStatus) public onlyOwner {
        if (_lightStatus > 0 ) {
            _lightStatus = 1;
        }    else {
                _lightStatus = 0;
            }
        lightStatus = _lightStatus;
        emit LightSet(_lightStatus);
    }
    
    //supposed to send ether to any caller of this function that executes it when it's green light
    function withdraw(uint withdraw_amount) public {
        // Limit the max withdrawal to 0.5 eth
        require(withdraw_amount <= 50000000000000000);
        if (lightStatus == 0) {
            payable(msg.sender).transfer(withdraw_amount);
        }   else {
            return;
        }
    }
    
    
    //supposed to fund this smart contract address so that users can call the "withdraw" function and get some ether when it's green light
    function Fund(address payable _toAddress, uint256 _amountInWei) external payable {
        address myAddress = address(this);
        if (myAddress.balance >= _amountInWei) {
            _toAddress.transfer(_amountInWei);
        }
    }
}