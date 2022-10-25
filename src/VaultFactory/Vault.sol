// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../Interfaces/IWETH.sol";

import "forge-std/console2.sol";

// import "lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";

contract Vault is ERC20 {
    // address public weth;
    bool campaignStatus;
    address public curator;
    address public token;

    uint256 public tokenId;
    uint256 public initialPrice;
    uint256 public supply;
    uint256 public deadline;

    // mapping(address => uint256) public balance;

    constructor(
        address _curator,
        string memory _erc20Name,
        string memory _erc20Symbol
    ) ERC20(_erc20Name, _erc20Symbol) {
        curator = _curator;
    }

    function depositNFT(
        address _token,
        uint256 _tokenId,
        uint256 _initialPrice,
        uint256 _supply,
        uint256 _deadline
    ) external {
        token = _token;
        tokenId = _tokenId;
        initialPrice = _initialPrice;
        deadline = _deadline;
        console2.log("Deadline is : ", deadline);
        supply = _supply;
        // _mint(address(this), _supply);
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);
        campaignStatus = true;
    }

    function invest(uint256 _investment) external payable {
        require(campaignStatus && deadline >= block.timestamp, "campaign paused");
        require(
            _investment <= initialPrice,
            "investment not greater than nft price"
        );
        require(msg.value == _investment, "invest amount must equal to ether");

        uint256 share = (_investment * 10000) / initialPrice;
        console2.log("Share in %", share);
        uint256 shareInTokens = (share * supply) / 10000;
        console2.log("share In Tokens", shareInTokens);

        (bool sent, ) = payable(address(this)).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
        _mint(msg.sender, shareInTokens);

        if (supply == totalSupply()) {
            campaignStatus = false;
        }
    }

    function withdrawNftAmount() external {
        require(
            !campaignStatus && deadline < block.timestamp,
            "time not ended"
        );
        require(initialPrice <= address(this).balance);

        payable(msg.sender).transfer(initialPrice);
        // list to marketplace
    }

    // function _sendETHOrWETH(address to, uint256 value) internal {
    //     // Try to transfer ETH to the given recipient.
    //     if (!_attemptETHTransfer(to, value)) {
    //         // If the transfer fails, wrap and send as WETH, so that
    //         // the auction is not impeded and the recipient still
    //         // can claim ETH via the WETH contract (similar to escrow).
    //         IWETH(weth).deposit{value: value}();
    //         IWETH(weth).transfer(to, value);
    //         // At this point, the recipient can unwrap WETH.
    //     }
    // }

    // function _attemptETHTransfer(address to, uint256 value)
    //     internal
    //     returns (bool)
    // {
    //     // Here increase the gas limit a reasonable amount above the default, and try
    //     // to send ETH to the recipient.
    //     // NOTE: This might allow the recipient to attempt a limited reentrancy attack.
    //     (bool success, ) = to.call{value: value, gas: 30000}("");
    //     return success;
    // }

    receive() external payable {}

    fallback() external payable {}

    function listToMarketplace() external {}
}
