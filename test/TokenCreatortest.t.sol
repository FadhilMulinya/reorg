// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "forge-std/Test.sol";
import "../src/TokenCreator.sol";

contract CustomTokenTest is Test {
    CustomToken public token;
    address public owner = address(0x123);
    address public feeReceiver = address(0x456);
    address public recipient = address(0x789);

    function setUp() public {
        token = new CustomToken("Test Token", "TT", 1000 * 10**18, 1, feeReceiver);
        token.transferOwnership(owner);
    }

    function testInitialSupply() public {
        uint256 expectedSupply = 1000 * 10**18;
        assertEq(token.balanceOf(owner), expectedSupply);
    }

    function testTransferFee() public {
        uint256 transferAmount = 100 * 10**18;
        uint256 feeAmount = (transferAmount * 1) / 100; // 1% fee

        token.transfer(owner, transferAmount);

        uint256 initialRecipientBalance = token.balanceOf(recipient);
        uint256 initialFeeReceiverBalance = token.balanceOf(feeReceiver);

        token.transfer(recipient, transferAmount);

        assertEq(token.balanceOf(recipient), initialRecipientBalance + (transferAmount - feeAmount));
        assertEq(token.balanceOf(feeReceiver), initialFeeReceiverBalance + feeAmount);
    }

    function testSetTransferFee() public {
        token.setTransferFee(5); // Set fee to 5%
        uint256 transferAmount = 100 * 10**18;
        uint256 feeAmount = (transferAmount * 5) / 100; // 5% fee

        token.transfer(owner, transferAmount);

        uint256 initialRecipientBalance = token.balanceOf(recipient);
        uint256 initialFeeReceiverBalance = token.balanceOf(feeReceiver);

        token.transfer(recipient, transferAmount);

        assertEq(token.balanceOf(recipient), initialRecipientBalance + (transferAmount - feeAmount));
        assertEq(token.balanceOf(feeReceiver), initialFeeReceiverBalance + feeAmount);
    }

    function testSetFeeReceiver() public {
        address newFeeReceiver = address(0xabc);
        token.setFeeReceiver(newFeeReceiver);

        uint256 transferAmount = 100 * 10**18;
        uint256 feeAmount = (transferAmount * 1) / 100; // 1% fee

        token.transfer(owner, transferAmount);

        uint256 initialNewFeeReceiverBalance = token.balanceOf(newFeeReceiver);

        token.transfer(recipient, transferAmount);

        assertEq(token.balanceOf(newFeeReceiver), initialNewFeeReceiverBalance + feeAmount);
    }
}
