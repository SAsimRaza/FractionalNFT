// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/ERC721Factory/ERC721Token.sol";
import "../src/VaultFactory/Vault.sol";
import "../src/ERC721Factory/TokenFactory.sol";
import "../src/VaultFactory/VaultFactory.sol";

import {IERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import "forge-std/Vm.sol";

contract TokenTest is Test {
    address admin = vm.addr(0x99);
    address curator = vm.addr(1);
    address investor1 = vm.addr(2);
    address investor2 = vm.addr(3);
    address other = vm.addr(4);

    ERC721Factory tokenFactory;
    VaultFactory vaultFactory;
    ERC721Token NFTtoken;

    address token;
    uint256 tokenId = 1;

    function setUp() public {
        tokenFactory = new ERC721Factory();
        vaultFactory = new VaultFactory();

        vm.deal(investor1, 10 ether);
        vm.deal(investor2, 10 ether);
        vm.deal(other, 10 ether);

        // Labelling addresses
        vm.label(admin, "Admin");
        vm.label(curator, "Zack");
        vm.label(investor1, "Alice");
        vm.label(investor2, "Bob");
        vm.label(other, "Other User");
    }

    function testCreateVault() public {
        // vm.startPrank(address(10000));
        changePrank(curator);
        token = tokenFactory.createToken("Test NFT", "Test");
        NFTtoken = ERC721Token(token);

        NFTtoken.mintNFT("www.google.com/NFT/1");

        address vault = vaultFactory.createVault("shiba", "SHB");
        assert(vault != address(0));
    }

    function testCreateVault_NftDeposit() public {
        changePrank(curator);
        token = tokenFactory.createToken("Test NFT", "Test");
        NFTtoken = ERC721Token(token);

        NFTtoken.mintNFT("www.google.com/NFT/1");

        address vault = vaultFactory.createVault("shiba", "SHB");

        IERC721(token).approve(vault, tokenId);

        Vault _vault = Vault(payable(vault));
        _vault.depositNFT(token, tokenId, 1 ether, 1000000e18, 10 days);

        assertEq(NFTtoken.ownerOf(tokenId), address(_vault));
    }

    function testInvestorShare() public {
        changePrank(curator);
        token = tokenFactory.createToken("Test NFT", "Test");
        NFTtoken = ERC721Token(token);

        NFTtoken.mintNFT("www.google.com/NFT/1");

        address vault = vaultFactory.createVault("shiba", "SHB");

        IERC721(token).approve(vault, tokenId);

        Vault _vault = Vault(payable(vault));
        _vault.depositNFT(token, tokenId, 1 ether, 1000000e18, 10 days);

        changePrank(investor1);
        _vault.invest{value: 0.5 ether}(0.5 ether);

        changePrank(investor2);
        _vault.invest{value: 0.5 ether}(0.5 ether);

        assertEq(IERC20(_vault).totalSupply(), 1000000e18);
    }

    function testInvestorShares() public {
        changePrank(curator);
        token = tokenFactory.createToken("Test NFT", "Test");
        NFTtoken = ERC721Token(token);

        NFTtoken.mintNFT("www.google.com/NFT/1");

        address vault = vaultFactory.createVault("shiba", "SHB");

        IERC721(token).approve(vault, tokenId);

        Vault _vault = Vault(payable(vault));
        _vault.depositNFT(token, tokenId, 1 ether, 1000000e18, 10 days);

        changePrank(investor1);
        _vault.invest{value: 0.5 ether}(0.5 ether);

        changePrank(investor2);
        _vault.invest{value: 0.5 ether}(0.5 ether);

        changePrank(other);
        vm.expectRevert(bytes("campaign paused"));
        _vault.invest{value: 0.5 ether}(0.5 ether);
    }
}
