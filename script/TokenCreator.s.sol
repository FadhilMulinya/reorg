// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "forge-std/Script.sol";
import "../src/TokenCreator.sol";

contract DeployCustomToken is Script {
    function run() public {
        // Set the network ID or RPC URL you want to deploy to
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Initialize the contract parameters
        string memory name = "Test Token";
        string memory symbol = "TT";
        uint256 totalSupply = 1000 * 10**18;
        uint256 transferFee = 1; // 1%
        address feeReceiver = 0x3346aF5A394052B7e48D38E6B806399757367C1b; // Replace with actual fee receiver address

        // Deploy the contract
        CustomToken token = new CustomToken(name, symbol, totalSupply, transferFee, feeReceiver);

        // Print the deployed contract address
        console.log("CustomToken deployed at:", address(token));

        vm.stopBroadcast();
    }
}
