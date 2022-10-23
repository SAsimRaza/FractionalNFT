// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ERC721Token is ERC721URIStorage {
    uint256 public tokenIds = 1;
    address public marketplace;

    constructor(
        string memory _name,
        string memory _symbol //address _marketPlace
    ) ERC721(_name, _symbol) {
        // marketPlace = _marketPlace;
    }

    function mintNFT(string memory _tokenURI) public {
        _safeMint(msg.sender, tokenIds);
        _setTokenURI(tokenIds, _tokenURI);
        setApprovalForAll(marketplace, true);
        tokenIds++;
    }
}
