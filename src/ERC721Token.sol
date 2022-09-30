// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC721} from "solmate/tokens/ERC721.sol";

contract ERC721Token is ERC721 {
    constructor(string memory _tokenUri) ERC721("NFT Basket Token", "NFT") {
        _mint(msg.sender, 0);
        
    }
}
