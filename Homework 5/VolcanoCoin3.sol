// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract VolanoCoin is ERC20, Ownable {

uint private _totalSupply;

event Transferred(address to, uint amount);

mapping(address => uint256) private _balances;

mapping(address => mapping(address => uint256)) private _allowances;

constructor () ERC20("VolcanoCoin", "VLC") {
    _totalSupply = 10000 * (10 **decimals());
    _balances[msg.sender] = _totalSupply;
    _mint(msg.sender, _totalSupply);
    
}

struct Payment {
    address sender;
    uint transfer_amount;
    address recipient_address;
}

mapping (address => Payment[]) public PaymentMapping;


function _mintToOwner(address _account, uint256 _amount) public onlyOwner {
    _mint(_account, _amount);
    emit Transfer(address(0), _account, _amount);
}

function getPayments(address _user) public view returns (Payment[] memory) {
    return PaymentMapping[_user];
}

function newPaymentRecord (address _sender, uint _amount, address _recipient) private {
    PaymentMapping[_sender].push(Payment(_sender, _amount, _recipient));
}

function transferWithPaymentRecord (uint _amount, address _recipient) public {
    _transfer(msg.sender, _recipient, _amount);
    newPaymentRecord(msg.sender, _amount, _recipient);
}    
}