// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract VolanoCoin is ERC20, Ownable {

uint public _totalSupply;

mapping(address => uint) balances;

event Transferred(address to, uint amount);

constructor () ERC20("VolcanoCoin", "VLC") {
    _totalSupply = 10000 * (10 **decimals());
    balances[msg.sender] = _totalSupply;
    _mint(msg.sender, 10000 * (10 **decimals()));
    
}

struct Payment {
    address sender;
    uint transfer_amount;
    address recipient_address;
}

mapping (address => Payment[]) PaymentMapping;
mapping(address => uint) public balance_list;


function transfer (address sender, uint _quantity, address _recipient) public {
    balance_list[msg.sender] -= _quantity;
    balance_list[_recipient] += _quantity;    
    PaymentMapping[msg.sender].push(Payment(sender, _quantity, _recipient));
    emit Transferred(_recipient, _quantity);
}

function _mintToOwner(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: mint to the zero address");
    _totalSupply += amount;
    balances[account] += amount;
    emit Transfer(address(0), account, amount);
    // _afterTokenTransfer(address(0), account, amount);
}



}