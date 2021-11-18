// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "hardhat-deploy/solc_0.8/proxy/Proxied.sol";
import "hardhat/console.sol";

contract FungibleBondingCurve is Proxied {
    event Entered(address indexed account, uint256 amount, uint256 contribution);
    event Exited(address indexed account, uint256 amount, uint256 contribution);

    uint256 public immutable linearCoefficientPer10Thousands;
    uint256 public immutable curveStart;

    uint256 public supply;

    mapping(address => uint256) public balanceOf;

    constructor(uint256 _curveStart, uint256 _linearCoefficientPer10Thousands) {
        curveStart = _curveStart;
        linearCoefficientPer10Thousands = _linearCoefficientPer10Thousands;
        postUpgrade(_curveStart, _linearCoefficientPer10Thousands);
    }

    // solhint-disable-next-line no-unused-vars
    function postUpgrade(
        uint256, // _curveStart,
        uint256 // _linearCoefficientPer10Thousands
    ) public proxied {
        // immutables are set in the constructor:
        // curveStart = _curveStart;
        // linearCoefficientPer10Thousands = _linearCoefficientPer10Thousands;
    }

    function enter(uint256 amount) external returns (uint256) {
        // amount is the amount of erc1155 to send along the transaction (transferFrom(msg.sender, address(this), id, amount))
        uint256 contributionForOne = _curve(supply);
        uint256 contribution = contributionForOne * amount;
        supply += contribution;
        balanceOf[msg.sender] += contribution;

        emit Entered(msg.sender, amount, contribution);
    }

    function exit(uint256 amount) external {
        uint256 contributionForOne = _curve(supply - 1);

        uint256 contribution = contributionForOne * amount;
        supply -= contribution;
        balanceOf[msg.sender] -= contribution;
        emit Exited(msg.sender, amount, contribution);
        // amount is the amount of erc1155 to send back (transferFrom(address(this),msg.sender, id, amount))
    }

    function _curve(uint256 supply) internal view returns (uint256) {
        return curveStart + ((supply * linearCoefficientPer10Thousands) / 10000);
    }
}
