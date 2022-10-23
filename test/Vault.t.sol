// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/ERC721Factory/ERC721Token.sol";
import "../src/VaultFactory/Vault.sol";
import "../src/ERC721Factory/TokenFactory.sol";
import "../src/VaultFactory/VaultFactory.sol";

import {IERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

contract TokenTest is Test {
    ERC721Factory tokenFactory;
    VaultFactory vaultFactory;
    ERC721Token NFTtoken;

    address token;
    uint256 tokenId = 1;

    function setUp() public {
        tokenFactory = new ERC721Factory();
        vaultFactory = new VaultFactory();
    }

    function testCreateVault() public {
        vm.startPrank(address(10000));
        token = tokenFactory.createToken("Test NFT", "Test");
        NFTtoken = ERC721Token(token);

        console.log("token address", token);

        NFTtoken.mintNFT("www.google.com/NFT/1");

        address vault = vaultFactory.createVault("shiba", "SHB");

        IERC721(token).approve(vault, tokenId);
        // address vault = vaultFactory.vaults[0];

        Vault _vault = Vault(payable(vault));
        _vault.depositNFT(token, tokenId, 1 ether, 1000000e18, 10 days);

        vm.stopPrank();
    }
}
