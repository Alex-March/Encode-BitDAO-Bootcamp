// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract VolcanoToken is ERC721, Ownable {

    constructor() ERC721("VolcanoNFT", "VNFT")  {
//        _name = "VolcanoNFT";
//        _symbol = "VNFT";
    }


    uint256 tokenID;

    struct metadata {
        uint timestamp;
        uint tokenID;
        string tokenURI;
    }

    mapping(address => metadata[]) ownershipMapping;

    function mintNFT(address _address, uint tokenID) public {

    }
    //metadata memory newTokenData = metadata(...)

    function awardItem(address ownershipMapping, string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function burnToken(address owner, uint tokenID) internal {
        require (ownerOf(tokenId) == owner, "cannot burn other addresse's tokens!");
        _clearApproval(tokenId);
        _ownedTokensCount[owner].decrement();
        _tokenOwner[tokenId] = address(0);
        emit Transfer(owner, address(0), tokenId);
    }

}