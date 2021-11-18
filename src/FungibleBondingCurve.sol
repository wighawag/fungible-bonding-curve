// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "hardhat-deploy/solc_0.8/proxy/Proxied.sol";
import "hardhat/console.sol";

contract FungibleBondingCurve is Proxied {
    event Entered(address indexed account, uint256 amount);

    function postUpgrade() public proxied {}

    // constructor() {}

    function enter(uint256 amount) external returns (uint256) {
        emit Entered(msg.sender, amount);
    }

    function exit(uint256 amount) external {}

    function balanceOf(address account) external view returns (uint256) {}
}
