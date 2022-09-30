// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// import "./ERC721Token.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721Factory {

    address[] public tokens; 

    event NewToken(address indexed _token, address indexed _creator);

    function createToken() external  {
        ERC721Token token = new ERC721Token();
        token.transferFrom(address(this),msg.sender,0);

        tokens.push(address(token));

        emit NewToken(address(token), msg.sender);
    }

}
