// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../Interfaces/IWETH.sol";

// import "lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";
// import "../utils/console.sol";

contract Vault is ERC20 {
    // address public weth;
    address public curator;
    address public token;

    uint256 public tokenId;
    uint256 public initialPrice;
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
        _mint(curator, _supply);
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);
    }

    function invest(uint256 _amountToInvest) external payable {
        require(deadline >= block.timestamp, "time ended");
        require(
            _amountToInvest <= initialPrice,
            "investment not greater than nft price"
        );
        require(
            msg.value == _amountToInvest,
            "invest amount must equal to ether"
        );

        uint256 share = (_amountToInvest * 10000) / initialPrice;
        // console.log("share got", share);

        uint256 shareInTokens = (share * totalSupply()) / 10000;

        transferFrom(curator, msg.sender, shareInTokens);
    }

    function withdrawNftAmount() external {
        require(deadline < block.timestamp, "time not ended");
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
