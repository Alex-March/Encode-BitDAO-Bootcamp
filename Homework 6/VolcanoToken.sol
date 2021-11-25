// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract VolcanoToken is ERC721, Ownable {

    constructor() ERC721("VolcanoNFT", "VNFT")  {
//        _name = "VolcanoNFT";
//        _symbol = "VNFT";
    }


    uint256 tokenID = 1;

    struct metadata {
        uint timestamp;
        uint tokenID;
        string tokenURI;
    }

    mapping(address => metadata[]) public ownershipMapping;

    function mintNFT(address _address) public {
        require(_address == msg.sender);
        _mint(_address, tokenID);
        ownershipMapping[_address].push(metadata(block.timestamp, tokenID, "Volcano"));
        tokenID += 1;
    }

    function burnNFT(uint _tokenID) public {
        require(super.ownerOf(_tokenID) == msg.sender);
        _burn(_tokenID);
        removeBurnedNFT(_tokenID);
    }

    function removeBurnedNFT(uint _tokenID) internal {
        metadata [] memory ownersTokens = ownershipMapping[msg.sender];
        delete ownershipMapping[msg.sender];
    }

    function tokenURI(uint256 _tokenID) public view override(ERC721) returns (string memory) {
        return super.tokenURI(_tokenID);
    }


}