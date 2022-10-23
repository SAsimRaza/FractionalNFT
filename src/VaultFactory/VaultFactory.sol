// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// import "../ERC721Factory/TokenFactory.sol";
import "./Vault.sol";

contract VaultFactory {
    address[] public vaults;

    function createVault(string memory _name, string memory _symbol)
        external
        returns (address _vault)
    {
        _vault = address(new Vault(msg.sender, _name, _symbol));
        vaults.push(_vault);
    }
}
