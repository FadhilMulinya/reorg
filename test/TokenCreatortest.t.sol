// CustomToken.t.sol
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TokenCreator.sol";

contract CustomTokenTest is Test {
    CustomToken public token;
    address public feeReceiver;
    address public user1;
    address public user2;

    function setUp() public {
        feeReceiver = address(1);
        user1 = address(2);
        user2 = address(3);

        token = new CustomToken("Custom Token", "CTK", 1000000, 5, feeReceiver);
    }

    function testTransfer() public {
        // Transfer 100 tokens from user1 to user2
        vm.prank(user1);
        token.transfer(user2, 100);

        // Check that user2 received 95 tokens (100 - 5% fee)
        assertEq(token.balanceOf(user2), 95);

        // Check that feeReceiver received 5 tokens (5% fee)
        assertEq(token.balanceOf(feeReceiver), 5);
    }

    function testTransferFrom() public {
        // Approve user1 to spend 100 tokens from user2
        vm.prank(user2);
        token.approve(user1, 100);

        // Transfer 100 tokens from user2 to user3 using user1 as spender
        vm.prank(user1);
        token.transferFrom(user1, user2, 100);

        // Check that user3 received 95 tokens (100 - 5% fee)
        assertEq(token.balanceOf(user2), 95);

        // Check that feeReceiver received 5 tokens (5% fee)
        assertEq(token.balanceOf(feeReceiver), 5);
    }

    function testTransferFee() public {
        // Transfer 100 tokens from user1 to user2 with a 10% fee
        vm.prank(user1);
        token.transfer(user2, 100);

        // Check that user2 received 90 tokens (100 - 10% fee)
        assertEq(token.balanceOf(user2), 90);

        // Check that feeReceiver received 10 tokens (10% fee)
        assertEq(token.balanceOf(feeReceiver), 10);
    }
}