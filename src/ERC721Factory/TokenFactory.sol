// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC721Token.sol";

contract ERC721Factory {
    address[] public tokens;

    event NewToken(address indexed _token, address indexed _creator);

    function createToken(string memory _name, string memory _symbol)
        external
        returns (address)
    {
        ERC721Token token = new ERC721Token(_name, _symbol);
        // token.transferFrom(address(this),msg.sender,0);

        tokens.push(address(token));

        emit NewToken(address(token), msg.sender);
        return address(token);
    }
}
